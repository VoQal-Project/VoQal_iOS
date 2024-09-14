//
//  LessonNoteDetailView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/6/24.
//

import UIKit

class LessonNoteDetailView: BaseView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "mainBackgroundColor")
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
    
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Medium", size: 21)
        label.translatesAutoresizingMaskIntoConstraints = false
    
        return label
    }()
    
    private let lessonSongLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexCode: "DADADA")
        label.font = UIFont(name: "SUIT-Medium", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let lessonContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Medium", size: 15)
        label.textColor = .white
        label.numberOfLines = .max
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Medium", size: 15)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lessonSongLabel)
        contentView.addSubview(verticalLine)
        contentView.addSubview(lessonContentLabel)
        contentView.addSubview(horizontalLine)
        contentView.addSubview(dateLabel)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -35),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            
            lessonSongLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lessonSongLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            lessonSongLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            
            verticalLine.leadingAnchor.constraint(equalTo: lessonSongLabel.leadingAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 2),
            verticalLine.heightAnchor.constraint(equalToConstant: 65),
            verticalLine.topAnchor.constraint(equalTo: lessonSongLabel.bottomAnchor, constant: 20),
            
            lessonContentLabel.leadingAnchor.constraint(equalTo: verticalLine.leadingAnchor),
            lessonContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35),
            lessonContentLabel.topAnchor.constraint(equalTo: verticalLine.bottomAnchor, constant: 20),
            
            horizontalLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalLine.topAnchor.constraint(equalTo: lessonContentLabel.bottomAnchor, constant: 30),
            horizontalLine.heightAnchor.constraint(equalToConstant: 2),
            
            dateLabel.topAnchor.constraint(equalTo: horizontalLine.bottomAnchor, constant: 25),
            dateLabel.leadingAnchor.constraint(equalTo: lessonContentLabel.leadingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30),
            
        ])
    }
    
    internal func setupUI(title: String, artist: String, songTitle: String, content: String, date: String) {
        titleLabel.text = title
        lessonSongLabel.text = "\(artist) - \(songTitle)"
        lessonContentLabel.text = content
        dateLabel.text = convertDateFormat(date)
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
