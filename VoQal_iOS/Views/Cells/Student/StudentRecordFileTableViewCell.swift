//
//  StudentRecordFileTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/5/24.
//

import UIKit

class StudentRecordFileTableViewCell: UITableViewCell {
    
    static let identifier = "studentRecordFileTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textColor = .white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let audioLengthLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textColor = .white.withAlphaComponent(0.8)
        label.text = "00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "474747")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StudentRecordFileTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(audioLengthLabel)
        contentView.addSubview(separatorLine)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            audioLengthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            audioLengthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
        ])

    }

    func configure(_ title: String, _ date: String, _ audioLength: String) {
        self.titleLabel.text = title
        self.dateLabel.text = date
        self.audioLengthLabel.text = audioLength
    }
    
}
