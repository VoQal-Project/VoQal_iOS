import UIKit
import FirebaseFirestore

class ChatViewController: BaseViewController {
    
    private let chatView = ChatView()
    private let chatManager = ChatManager()
    
    private var studentId: Int64? = nil
    private var coachId: Int64? = nil
    private var chatRoomId: String? = nil
    private var messages: [ChatMessage] = []
    private var messageTimestamps: Set<Int> = Set()
    private var listener: ListenerRegistration?
    
    private var lastReadTime: Int64? = nil
    private var lastTimeStampLocal: Int64 = 0
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        chatView.tableView.register(ReceiverMessageCell.self, forCellReuseIdentifier: ReceiverMessageCell.identifier)
        chatView.tableView.register(SenderMessageCell.self, forCellReuseIdentifier: SenderMessageCell.identifier)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        startObservingKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enterChattingRoom(studentId)
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isUserInChatRoom = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let lastReadTimeStamp = CacheManager.shared.getLastReadTime() {
            updateLastReadTimeToDB(lastReadTimeStamp)
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.isUserInChatRoom = false
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func appDidEnterBackground() {
        if let lastReadTime = CacheManager.shared.getLastReadTime() {
            updateLastReadTimeToDB(lastReadTime)
        }
    }
    
    @objc private func appWillTerminate() {
        if let lastReadTime = CacheManager.shared.getLastReadTime() {
            updateLastReadTimeToDB(lastReadTime)
        }
    }
    
    override func setAddTarget() {
        chatView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureStudentId(_ studentId: Int64) {
        self.studentId = studentId
    }
    
    private func enterChattingRoom(_ studentId: Int64?) {
        guard let role = UserManager.shared.userModel?.role else { print("enterChattingRoom - role is nil"); return }
        if role == "COACH" {
            guard let studentId = studentId else { print("enterChattingRoom - studentId is nil"); return }
            chatManager.searchChatRoomFromCoach(studentId) { [weak self] model in
                guard let model = model, let self = self else { print("searchChatRoomFromCoach - model or self is nil"); return }
                
                if model.status == 200 {
                    guard let chatId = model.data else { print("model.data is nil"); return }
                    
                    self.chatRoomId = chatId
                    fetchMessages(chatId)
                    listenForMessages(self.chatRoomId ?? "")
                    print("chatId: \(chatId)")
                }
            }
        }
        else if role == "STUDENT" {
            chatManager.searchChatRoomFromStudent { [weak self] model in
                guard let model = model, let self = self else { print("searchChatRoomFromStudent - model or self is nil"); return }
                
                if model.status == 200 {
                    guard let data = model.data else { print("model.data is nil"); return }
                    
                    self.chatRoomId = data.chatRoomId
                    self.coachId = Int64(data.coachId)
                    fetchMessages(data.chatRoomId)
                    listenForMessages(self.chatRoomId ?? "")
                    print("chatId: \(data.chatRoomId)")
                }
            }
        }
        else {
            print("role이 올바르지 않습니다.")
        }
    }
    
    private func fetchMessages(_ chatId: String) {
        chatManager.fetchMessages(chatId) { [weak self] model in
            guard let model = model, let self = self else { print("fetchMessages - model or self is nil"); return }
            guard let role = UserManager.shared.userModel?.role else { print("fetchMessages - role is nil"); return }
            
            if model.status == 200 {
                
                // 사용자의 역할에 따라 마지막 읽은 시간 설정
                if role == "COACH" {
                    self.lastReadTime = model.coachLastReadTime
                } else if role == "STUDENT" {
                    self.lastReadTime = model.studentLastReadTime
                }
                
                // 메시지 리스트를 순회하면서 바로 추가 (중복 체크 X)
                for message in model.messages {
                    self.messages.append(message)
                    self.messageTimestamps.insert(message.timestamp) // Set에 타임스탬프 추가
                }
                
                self.chatView.tableView.reloadData()
            } else {
                print("fetchMessages - model.status is not 200")
            }
        }
    }
    
    @objc private func sendMessage() {
        guard let message = chatView.messageInputView.text, !message.isEmpty else { return }
        var receiverId: Int64
        
        if UserManager.shared.userModel?.role == "COACH" {
            guard let studentId = self.studentId else { print("studentId is nil"); return }
            receiverId = studentId
            
            guard let chatRoomId = self.chatRoomId else { print("chatRoomId is nil"); return }
            
            chatManager.sendMessage(chatRoomId, receiverId, message) { [weak self] model in
                guard let model = model, let self = self else { print("sendMessage - model or self is nil"); return }
                
                chatView.messageInputView.text = ""
            }
        }
        else if UserManager.shared.userModel?.role == "STUDENT" {
            guard let coachId = self.coachId else { print("coachId is nil"); return }
            receiverId = coachId
            
            guard let chatRoomId = self.chatRoomId else { print("chatRoomId is nil"); return }
            
            chatManager.sendMessage(chatRoomId, receiverId, message) { [weak self] model in
                guard let model = model, let self = self else { print("sendMessage - model or self is nil"); return }
                
                chatView.messageInputView.text = ""
            }
        }
    }
    
    private func listenForMessages(_ chatRoomId: String) {
        let db = Firestore.firestore()
        
        if listener == nil {
            listener = db.collection("chats")
                .document(chatRoomId)
                .collection("messages")
                .order(by: "timestamp", descending: false)
                .addSnapshotListener({ [weak self] snapshot, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error fetching messages: \(error)")
                        return
                    }
                    
                    guard let snapshot = snapshot else { print("listenForMessages - snapshot is nil"); return }
                    
                    for diff in snapshot.documentChanges {
                        if diff.type == .added {
                            let data = diff.document.data()
                            if let receiverId = data["receiverId"] as? String,
                               let message = data["message"] as? String,
                               let timestamp = data["timestamp"] as? Int {
                                
                                // Set에서 중복 여부 확인 후 추가
                                if !self.messageTimestamps.contains(timestamp) {
                                    let chatMessage = ChatMessage(receiverId: receiverId, message: message, timestamp: timestamp)
                                    self.messages.append(chatMessage)
                                    self.messageTimestamps.insert(timestamp) // 새로운 메시지의 타임스탬프 추가
                                    
                                    self.updateLastReadMessageInCache(timestamp)
                                }
                            }
                        }
                    }
                    
                    self.chatView.tableView.reloadData()
                    self.scrollToBottom()
                })
        }
    }
    
    private func updateLastReadMessageInCache(_ timeStamp: Int) {
        CacheManager.shared.saveLastReadTime(timeStamp)
    }
    
    private func updateLastReadTimeToDB(_ lastReadTime: Int) {
        guard let chatId = self.chatRoomId else { print("updateLastReadTimeToDB - chatId is nil"); return }
        let role = UserManager.shared.userModel?.role ?? "STUDENT"
        
        // Firestore에 저장하는 코드
        let db = Firestore.firestore()
        let chatRoomRef = db.collection("chats").document(chatId)
        
        let lastReadField = role == "COACH" ? "coachLastReadTime" : "studentLastReadTime"
        
        chatRoomRef.updateData([lastReadField: lastReadTime]) { error in
            if let error = error {
                print("Firestore update failed: \(error)")
            }
            else {
                print("Firestore update successful")
            }
        }
    }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        chatView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func startObservingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.3) {
                self.chatView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.chatView.transform = .identity
        }
    }
    
    private func addSeparatorBelowCell(_ cell: UITableViewCell) {
        let separator = UIView(frame: CGRect(x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1))
        separator.backgroundColor = UIColor.red
        cell.contentView.addSubview(separator)
    }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        guard let currentUserId = UserManager.shared.userModel?.memberId else {
            print("userModel.memberId is nil"); return UITableViewCell()
        }
        
        if message.receiverId == String(currentUserId) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverMessageCell.identifier, for: indexPath) as? ReceiverMessageCell else {
                return UITableViewCell()
            }
            cell.configure(DateUtility.convertTimestamp(message.timestamp), message.message)
            
            if let lastReadTime = self.lastReadTime {
                if message.timestamp == lastReadTime {
                    addSeparatorBelowCell(cell)
                }
            }
            
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SenderMessageCell.identifier, for: indexPath) as? SenderMessageCell else {
                return UITableViewCell()
            }
            cell.configure(DateUtility.convertTimestamp(message.timestamp), message.message)
            
            if let lastReadTime = self.lastReadTime {
                if message.timestamp == lastReadTime {
                    addSeparatorBelowCell(cell)
                }
            }
            
            return cell
        }
    }
    
}
