//
//  StudentsTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/23/24.
//

import UIKit

class StudentsTableViewCell: UITableViewCell {
    
    static let identifier: String = "StudentsTableViewCell"
    
    private let studentName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RequestListTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
//        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.addSubview(studentName)
        contentView.addSubview(separatorLine)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            studentName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            studentName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            studentName.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
        ])
        
    }
    
    internal func configure(_ name: String) {
        studentName.text = name
    }
    
}
