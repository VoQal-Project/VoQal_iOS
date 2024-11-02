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
    
    private var lastReadMessageIndex: Int? {
        guard let lastReadTime = self.lastReadTime else { return nil }
        return messages.lastIndex { $0.timestamp <= lastReadTime }
    }
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        chatView.tableView.register(ReceiverMessageCell.self, forCellReuseIdentifier: ReceiverMessageCell.identifier)
        chatView.tableView.register(SenderMessageCell.self, forCellReuseIdentifier: SenderMessageCell.identifier)
        chatView.tableView.register(ReadReceiptCell.self, forCellReuseIdentifier: ReadReceiptCell.identifier)
        
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
                
                if let lastReadTime = self.lastReadTime {
                    self.updateLastReadMessageInCache(Int(lastReadTime))
                }
                
                self.chatView.tableView.reloadData()
                self.scrollToSpecificMessage()
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
        
        if listener != nil {
            return
        }
        
        var isFirstSnapshot = true
        
        listener = db.collection("chats")
            .document(chatRoomId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("listenForMessages - snapshot is nil")
                    return
                }
                
                // 첫 번째 스냅샷은 무시하고 이후부터 데이터 추가
                if isFirstSnapshot {
                    isFirstSnapshot = false
                    return
                }
                
                // 이후 변경 사항만 추가
                for diff in snapshot.documentChanges {
                    if diff.type == .added {
                        let data = diff.document.data()
                        if let receiverId = data["receiverId"] as? String,
                           let message = data["message"] as? String,
                           let timestamp = data["timestamp"] as? Int {
                            
                            if !self.messageTimestamps.contains(timestamp) {
                                let chatMessage = ChatMessage(receiverId: receiverId, message: message, timestamp: timestamp)
                                self.messages.append(chatMessage)
                                self.messageTimestamps.insert(timestamp)
                                
                                self.updateLastReadMessageInCache(timestamp)
                            }
                        }
                    }
                }
                
                self.chatView.tableView.reloadData()
                self.scrollToBottom()
            }
    }
    
    private func updateLastReadMessageInCache(_ timeStamp: Int) {
        print("timeStamp in cache updated: \(timeStamp)")
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
        
        // 마지막 row의 인덱스 계산
        let lastRow: Int
        if let lastReadIndex = lastReadMessageIndex, lastReadIndex < messages.count - 1 {
            // 구분선이 있는 경우 (마지막으로 읽은 메시지가 있고, 그 이후에 새 메시지가 있는 경우)
            lastRow = messages.count  // messages.count + 1 - 1
        } else {
            // 구분선이 없는 경우
            lastRow = messages.count - 1
        }
        
        let indexPath = IndexPath(row: lastRow, section: 0)
        chatView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        if let lastMessageTimestamp = messages.last?.timestamp {
            updateLastReadMessageInCache(lastMessageTimestamp)
        }
        
        print("scroll to bottom - lastRow: \(lastRow)")
    }

    // scrollToSpecificMessage도 같은 방식으로 수정
    private func scrollToSpecificMessage() {
        if let lastReadTime = self.lastReadTime,
           let index = messages.firstIndex(where: { $0.timestamp == lastReadTime }) {
            
            // 구분선이 있는 경우를 고려한 인덱스 계산
            let targetIndex: Int
            if index < messages.count - 1 {
                // 구분선이 표시되는 경우 (마지막으로 읽은 메시지 다음에 새 메시지가 있는 경우)
                targetIndex = index + 1  // 구분선 위치로 스크롤
            } else {
                // 구분선이 없는 경우
                targetIndex = index
            }
            
            let indexPath = IndexPath(row: targetIndex, section: 0)
            chatView.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            
            // 모든 메시지를 확인한 것으로 간주하여 최신 메시지로 읽음 상태 갱신
            if let latestMessageTimestamp = messages.last?.timestamp {
                updateLastReadMessageInCache(latestMessageTimestamp)
            }
            
            print("읽지 않은 메시지 전 챗으로 이동 - targetIndex: \(targetIndex)")
        } else {
            // 마지막 읽은 메시지가 없을 경우 최신 메시지로 스크롤
            print("마지막 챗으로 이동")
            scrollToBottom()
        }
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
        let separatorTag = 999
        if cell.contentView.viewWithTag(separatorTag) == nil {
            let separator = UIView(frame: CGRect(x: 0, y: cell.frame.height - 1, width: cell.frame.width, height: 1))
            separator.backgroundColor = UIColor.red
            separator.tag = separatorTag // Assign a tag to the separator view
            cell.contentView.addSubview(separator)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messageCount = messages.count
        // 마지막으로 읽은 메시지가 있고, 그 이후에 메시지가 있는 경우에만 구분선 추가
        if let lastIndex = lastReadMessageIndex, lastIndex < messageCount - 1 {
            return messageCount + 1
        }
        return messageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 마지막으로 읽은 메시지 다음 위치에 구분선 셀 삽입
        if let lastIndex = lastReadMessageIndex,
           indexPath.row == lastIndex + 1,
           lastIndex < messages.count - 1 {
            guard let separatorCell = tableView.dequeueReusableCell(withIdentifier: ReadReceiptCell.identifier, for: indexPath) as? ReadReceiptCell else {
                return UITableViewCell()
            }
            return separatorCell
        }
        
        // 실제 메시지 인덱스 계산
        var messageIndex = indexPath.row
        if let lastIndex = lastReadMessageIndex, indexPath.row > lastIndex + 1 {
            messageIndex = indexPath.row - 1  // 구분선 이후의 메시지는 인덱스를 하나 줄임
        }
        
        // 인덱스가 유효한지 확인
        guard messageIndex < messages.count else {
            return UITableViewCell()
        }
        
        // 기존 메시지 셀 로직
        let message = messages[messageIndex]
        guard let currentUserId = UserManager.shared.userModel?.memberId else {
            return UITableViewCell()
        }
        
        if message.receiverId == String(currentUserId) {
            guard let receiverCell = tableView.dequeueReusableCell(withIdentifier: ReceiverMessageCell.identifier, for: indexPath) as? ReceiverMessageCell else {
                return UITableViewCell()
            }
            receiverCell.configure(DateUtility.convertTimestamp(message.timestamp), message.message)
            return receiverCell
        } else {
            guard let senderCell = tableView.dequeueReusableCell(withIdentifier: SenderMessageCell.identifier, for: indexPath) as? SenderMessageCell else {
                return UITableViewCell()
            }
            senderCell.configure(DateUtility.convertTimestamp(message.timestamp), message.message)
            return senderCell
        }
    }
    
    
    
}
