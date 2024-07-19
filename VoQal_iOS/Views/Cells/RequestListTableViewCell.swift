//
//  RequestListTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

class RequestListTableViewCell: UITableViewCell {

    static let identifier: String = "RequestListTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let approveButton: UIButton = {
        let button = UIButton()
        button.setTitle("승인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("거절", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(hexCode: "181818", alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RequestListTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name name: String) {
        nameLabel.text = name
    }
    
    private func addSubViews() {
        addSubview(nameLabel)
        addSubview(approveButton)
        addSubview(rejectButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 60),
            
            approveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            approveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            approveButton.widthAnchor.constraint(equalToConstant: 54),
            approveButton.heightAnchor.constraint(equalToConstant: 27),
            
            
        ])
    }

}
