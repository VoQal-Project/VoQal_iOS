//
//  RecordFileListTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import UIKit

class RecordFileListTableViewCell: UITableViewCell {
    
    static let identifier = "recordFileListTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.text = "타이틀"
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.text = "24.10.13"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: RecordFileListTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        addSubViews()
        setConstraints()
        setAddTarget()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    private func setAddTarget() {
        
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
    }

    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
    }
    
    func configureCell(title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }

}
