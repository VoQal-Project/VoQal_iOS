//
//  CoachSelectionView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/9/24.
//

import UIKit

class CoachSelectionView: UIView {
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.text = "담당 코치님을 선택해주세요."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 21)
        label.font = UIFont.systemFont(ofSize: 21)
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        return label
    }()
    
    internal let coachTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        return tableView
    }()
    
    internal let applyCoachButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.backgroundColor = UIColor.white
        button.tintColor = UIColor(named: "mainBackgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCoachButton.layer.cornerRadius = applyCoachButton.frame.height / 2
    }
    
    private func addSubViews() {
        addSubview(introLabel)
        addSubview(coachTableView)
        addSubview(applyCoachButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            introLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            introLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: -270),
            introLabel.widthAnchor.constraint(equalToConstant: 320),
            introLabel.heightAnchor.constraint(equalToConstant: 50),
            
            coachTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            coachTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            coachTableView.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 35),
            coachTableView.heightAnchor.constraint(equalToConstant: 400),
            
            applyCoachButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            applyCoachButton.topAnchor.constraint(equalTo: coachTableView.bottomAnchor, constant: 20),
            applyCoachButton.widthAnchor.constraint(equalToConstant: 45),
            applyCoachButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    
    
    
}
