import UIKit

class ChatViewController: BaseViewController {
    
    private let chatView = ChatView()
    private let chatManager = ChatManager()
    
    private var messages: [String] = [] // 샘플 메시지 데이터
    
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
    
    override func setAddTarget() {
        chatView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func enterChattingRoom(_ studentId: Int64) {
        
    }
    
    @objc private func sendMessage() {
        guard let message = chatView.messageInputView.text, !message.isEmpty else { return }
//        let chatMessage = ChatMessage(receiverId: <#T##String#>, message: <#T##String#>, timestamp: <#T##Int#>)
        messages.append(message)
        chatView.messageInputView.text = ""
        chatView.tableView.reloadData()
    }
    
    private func scrollToBottom() {
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
    
//    private func adjustForKeyboard(notification: NSNotification, show: Bool) {
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        let adjustmentHeight = show ? keyboardFrame.height : 0
//        chatView.tableView.contentInset.bottom = adjustmentHeight
////        scrollToBottom()
//    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SenderMessageCell.identifier, for: indexPath) as? SenderMessageCell else { return UITableViewCell() }
        cell.configure("13:33", messages[indexPath.row])
        return cell
    }
    
}
