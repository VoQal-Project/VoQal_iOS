//
//  MyPageMenuTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/20/24.
//

import UIKit

class MyPageMenuTableViewCell: UITableViewCell {
    
    static let identifier: String = "myPageMenuTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Medium", size: 18)
        label.textColor = .white
        
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: MyPageMenuTableViewCell.identifier)
        
        contentView.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorLine)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
        ])
        
    }
    
    func configure(_ title: String, _ lastCell: Bool) {
        titleLabel.text = title
        separatorLine.isHidden = lastCell
        if lastCell {
            titleLabel.textColor = UIColor(hexCode: "FF3B30", alpha: 1.0)
        }
    }

}
