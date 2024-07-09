//
//  RoleSelectionView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/9/24.
//

import UIKit

class RoleSelectionView: UIView {
    
    private let studentLabel: UILabel = {
        let label = UILabel()
        label.text = "학생이신가요?"
        label.font = UIFont(name: "SUIT-SemiBold", size: 15)
        label.textColor = .white
        return label
    }()
    
    private let coachLabel: UILabel = {
        let label = UILabel()
        label.text = "코치이신가요?"
        label.font = UIFont(name: "SUIT-SemiBold", size: 15)
        label.textColor = .white
        return label
    }()
    
    internal let coachButton = RoleSelectionButton(title: "코치", icon: UIImage(systemName: "headphones")!)
    internal let studentButton = RoleSelectionButton(title: "학생", icon: UIImage(systemName: "music.mic")!)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        addSubViews()
        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        addSubview(coachButton)
        addSubview(studentButton)
        addSubview(coachLabel)
        addSubview(studentLabel)
    }
    
    private func setConstraints() {
        coachLabel.translatesAutoresizingMaskIntoConstraints = false
        studentLabel.translatesAutoresizingMaskIntoConstraints = false
        coachButton.translatesAutoresizingMaskIntoConstraints = false
        studentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            coachButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -85),
            coachButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            coachButton.widthAnchor.constraint(equalToConstant: 145),
            coachButton.heightAnchor.constraint(equalToConstant: 175),
            
            studentButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 85),
            studentButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            studentButton.widthAnchor.constraint(equalToConstant: 145),
            studentButton.heightAnchor.constraint(equalToConstant: 175),
            
            coachLabel.centerXAnchor.constraint(equalTo: coachButton.centerXAnchor),
            coachLabel.bottomAnchor.constraint(equalTo: coachButton.topAnchor, constant: -15),
            
            studentLabel.centerXAnchor.constraint(equalTo: studentButton.centerXAnchor),
            studentLabel.bottomAnchor.constraint(equalTo: studentButton.topAnchor, constant: -15),
            
            
        ])
        
    }
    
}
