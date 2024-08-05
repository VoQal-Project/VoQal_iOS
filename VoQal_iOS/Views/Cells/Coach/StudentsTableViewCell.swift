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
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let lessonSongButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 15)
        button.titleLabel?.textColor = .white
        button.setTitle("로이킴 - 봄이 와도", for: .normal)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        contentView.addSubview(lessonSongButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            studentName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            studentName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            studentName.widthAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            lessonSongButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            lessonSongButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lessonSongButton.widthAnchor.constraint(equalToConstant: 170),
        ])
        
    }
    
    internal func configure(_ name: String, target: Any, _ action: Selector, _ indexPath: IndexPath, _ singer: String?, _ songTitle: String?) {
        studentName.text = name
        lessonSongButton.tag = indexPath.row
        lessonSongButton.addTarget(target, action: action, for: .touchUpInside)
        
        if let singer = singer, let songTitle = songTitle {
            lessonSongButton.setTitle("\(singer) - \(songTitle)", for: .normal)
        } else {
            lessonSongButton.setTitle("레슨곡을 설정해주세요.", for: .normal)
            lessonSongButton.setTitleColor(UIColor(hexCode: "474747"), for: .normal)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lessonSongButton.setTitleColor(.none, for: .normal)
    }
    
}
