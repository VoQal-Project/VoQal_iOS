//
//  LessonNoteListTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 11/4/24.
//

import UIKit

class LessonNoteListTableViewCell: UITableViewCell {
    
    static let identifier = "lessonNoteListTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.text = "타이틀"
        
        return label
    }()
    
    private let lessonSongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.textColor = .white
        label.text = "가수 - 곡명"
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.text = "24.10.30"
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: LessonNoteListTableViewCell.identifier)
        
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
        contentView.addSubview(lessonSongLabel)
        contentView.addSubview(dateLabel)
    }

    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            
            lessonSongLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            lessonSongLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
        ])
        
    }
    
    func configureCell(title: String, songTitle: String, singer: String, date: String) {
        titleLabel.text = title
        lessonSongLabel.text = "\(singer) - \(songTitle)"
        dateLabel.text = date
    }
    
}
