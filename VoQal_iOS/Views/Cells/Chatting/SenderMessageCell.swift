//
//  SenderMessageCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/14/24.
//

import UIKit

class SenderMessageCell: UITableViewCell {

    static let identifier = "SenderMessageCell"
    
    private let messageBox: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        textView.backgroundColor = UIColor(named: "chatColor")
        textView.layer.cornerRadius = 10.0
        textView.layer.cornerCurve = .continuous
        textView.textColor = .white
        textView.font = UIFont(name: "SUIT-Regular", size: 13)
        textView.sizeToFit()
        textView.text = "안녕하세요"
        
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.text = "13:33"
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: SenderMessageCell.identifier)
        
        selectionStyle = .none
        addSubViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func addSubViews() {
        contentView.addSubview(messageBox)
        contentView.addSubview(dateLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            messageBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            messageBox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            messageBox.heightAnchor.constraint(greaterThanOrEqualToConstant: 45),
            messageBox.widthAnchor.constraint(lessThanOrEqualToConstant: 255),
            messageBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: messageBox.leadingAnchor, constant: -5),
            dateLabel.bottomAnchor.constraint(equalTo: messageBox.bottomAnchor, constant: 0),
        ])
    }

    func configure(_ time: String, _ message: String) {
        messageBox.text = message
    }
    
}


