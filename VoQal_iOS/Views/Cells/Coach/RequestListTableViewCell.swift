//
//  RequestListTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

protocol RequestListTableViewCellDelegate: AnyObject {
    func didTapApproveButton(in cell: RequestListTableViewCell)
    func didTapRejectButton(in cell: RequestListTableViewCell)
}

class RequestListTableViewCell: UITableViewCell {

    static let identifier: String = "RequestListTableViewCell"
    
    weak var delegate: RequestListTableViewCellDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let approveButton: UIButton = {
        let button = UIButton()
        button.setTitle("승인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
        button.layer.cornerRadius = 7.0
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  // 사용자 인터랙션 활성화
        return button
    }()
    
    internal let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitle("거절", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
        button.layer.cornerRadius = 7.0
        button.backgroundColor = UIColor(hexCode: "181818", alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true  // 사용자 인터랙션 활성화
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RequestListTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        
        addSubViews()
        setConstraints()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
    
    private func setAddTarget() {
        approveButton.addTarget(self, action: #selector(didTapApproveButton), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(didTapRejectButton), for: .touchUpInside)
        print("Targets added to buttons")  // 디버깅 메시지 추가
    }
    
    private func addSubViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(approveButton)
        contentView.addSubview(rejectButton)
        contentView.addSubview(separatorLine)
        
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
            
            rejectButton.leadingAnchor.constraint(equalTo: approveButton.trailingAnchor, constant: 10),
            rejectButton.widthAnchor.constraint(equalToConstant: 54),
            rejectButton.heightAnchor.constraint(equalToConstant: 27),
            rejectButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc private func didTapApproveButton() {
        print("didTapApproveButton")
        delegate?.didTapApproveButton(in: self)
    }
    
    @objc private func didTapRejectButton() {
        print("didTapRejectButton")
        delegate?.didTapRejectButton(in: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }
}
