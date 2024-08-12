//
//  StudentLessonNoteTableViewCell.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/5/24.
//

import UIKit

class StudentLessonNoteTableViewCell: UITableViewCell {

    static let identifier = "studentLessonNoteTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "1F1F1F")
        view.layer.cornerRadius = 10.0
        view.layer.cornerCurve = .continuous
        
        return view
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        
        return view
    }()
    
    private let lessonTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-SemiBold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let lessonSongLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.8)
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Medium", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: StudentLessonNoteTableViewCell.identifier)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        selectionStyle = .none
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(lessonTitleLabel)
        containerView.addSubview(lessonSongLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(separatorLine)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.5),
            
            lessonTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            lessonTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            lessonTitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: containerView.trailingAnchor, constant: -25),
            
            lessonSongLabel.topAnchor.constraint(equalTo: lessonTitleLabel.bottomAnchor, constant: 10),
            lessonSongLabel.leadingAnchor.constraint(equalTo: lessonTitleLabel.leadingAnchor),
            lessonSongLabel.trailingAnchor.constraint(equalTo: lessonTitleLabel.trailingAnchor),
            
            separatorLine.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            separatorLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        
        ])
    }
    
    func configure(_ title: String, _ artist: String, _ songTitle: String, _ date: String) {
        self.lessonTitleLabel.text = title
        self.lessonSongLabel.text = "\(artist)-\(songTitle)"
        self.dateLabel.text = convertDateFormat(date)
    }
    
    private func convertDateFormat(_ inputDate: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = inputFormatter.date(from: inputDate) else { print("convertDateFormat 실패"); return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"
        
        return outputFormatter.string(from: date)
    }
    
}
