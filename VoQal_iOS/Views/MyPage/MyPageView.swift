//
//  MyPageView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/14/24.
//

import UIKit

class MyPageView: BaseView {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Medium", size: 23)
        label.textColor = .white
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Medium", size: 15)
        label.textColor = .white
        
        return label
    }()
    
    private let coachLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Medium", size: 15)
        label.textColor = .white
        
        return label
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 변경", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.cornerCurve = .continuous
        button.titleLabel?.textColor = .white
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.titleLabel?.font = UIFont(name: "SUIT-Medium", size: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "1F1F1F", alpha: 1.0)
        
        return view
    }()
    
    internal let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainBackgroundColor")
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(nameLabel)
        addSubview(nicknameLabel)
        addSubview(coachLabel)
        addSubview(editProfileButton)
        addSubview(separatorView)
        addSubview(menuTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nicknameLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            coachLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            coachLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            editProfileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            editProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            editProfileButton.heightAnchor.constraint(equalToConstant: 30),
            editProfileButton.topAnchor.constraint(equalTo: coachLabel.bottomAnchor, constant: 20),
            
            separatorView.heightAnchor.constraint(equalToConstant: 10),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 20),
            
            menuTableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            menuTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configure(_ name: String, _ nickname: String, _ coachName: String) {
        nameLabel.text = name
        nicknameLabel.text = nickname
        coachLabel.text = "with \(coachName) 코치님"
    }
    
}
