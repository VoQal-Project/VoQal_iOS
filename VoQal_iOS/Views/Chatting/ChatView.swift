//
//  ChatView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/14/24.
//

import UIKit
import SwiftUI

class ChatView: BaseView {
    
    internal let messageInputView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 10
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.keyboardType = .default
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no

        return textView
    }()
    
    internal let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
        
        backgroundColor = UIColor(hexCode: "1F1F1F", alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        addSubview(tableView)
        addSubview(messageInputView)
        addSubview(sendButton)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor, constant: -10),
            
            // MessageInput Constraints
            messageInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            messageInputView.heightAnchor.constraint(equalToConstant: 36),
            
            // SendButton Constraints
            sendButton.leadingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor)
        ])
    }
    
}
// SwiftUI PreviewProvider를 사용해 UIKit 뷰 미리보기
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let chatView = ChatView()
            chatView.frame = CGRect(x: 0, y: 0, width: 375, height: 100) // 원하는 크기 설정
            return chatView
        }
        .previewLayout(.sizeThatFits) // 적절한 크기로 미리보기
    }
}

// UIKit 뷰를 SwiftUI에서 미리보기 할 수 있게 하는 Helper Struct
struct ChatViewPreview: UIViewRepresentable {
    let view: UIView
    
    init(_ builder: @escaping () -> UIView) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
