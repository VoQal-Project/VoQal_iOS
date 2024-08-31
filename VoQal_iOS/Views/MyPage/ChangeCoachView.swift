//
//  ChangeCoachView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/25/24.
//

import UIKit

class ChangeCoachView: BaseView {
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 코치님으로 변경하시겠어요?"
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
    
    internal let changeCoachButton: UIButton = {
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
        changeCoachButton.layer.cornerRadius = changeCoachButton.frame.height / 2
    }
    
    override func addSubViews() {
        addSubview(introLabel)
        addSubview(coachTableView)
        addSubview(changeCoachButton)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            introLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            introLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: -270),
            introLabel.widthAnchor.constraint(equalToConstant: 320),
            introLabel.heightAnchor.constraint(equalToConstant: 50),
            
            coachTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            coachTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            coachTableView.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 35),
            coachTableView.heightAnchor.constraint(equalToConstant: 400),
            
            changeCoachButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            changeCoachButton.topAnchor.constraint(equalTo: coachTableView.bottomAnchor, constant: 20),
            changeCoachButton.widthAnchor.constraint(equalToConstant: 45),
            changeCoachButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    

}
