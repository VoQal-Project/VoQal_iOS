//
//  ChatView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/14/24.
//

import UIKit

class ChatView: BaseView, UITextViewDelegate {
    
    private var messageInputViewHeightConstraint: NSLayoutConstraint!
    
    internal let messageInputView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 10
        textView.font = UIFont(name: "SUIT-Regular", size: 16)
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
        messageInputView.delegate = self
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
        
        messageInputViewHeightConstraint = messageInputView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        
        NSLayoutConstraint.activate([
            // TableView Constraints
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor, constant: -10),
            
            // MessageInput Constraints
            messageInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageInputView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            messageInputView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageInputViewHeightConstraint,
            messageInputView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            // SendButton Constraints
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            sendButton.centerYAnchor.constraint(equalTo: messageInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
            let size = CGSize(width: textView.frame.width, height: .infinity)
            let estimatedSize = textView.sizeThatFits(size)

            // 텍스트뷰 높이에 따라 스크롤 설정 및 높이 조정
            if estimatedSize.height > 100 {
                messageInputViewHeightConstraint.constant = 100
                textView.isScrollEnabled = true
            } else if estimatedSize.height <= 40 {
                messageInputViewHeightConstraint.constant = 40
                textView.isScrollEnabled = false
            } else {
                messageInputViewHeightConstraint.constant = estimatedSize.height
                textView.isScrollEnabled = false
            }

            // 레이아웃 업데이트
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    
}
