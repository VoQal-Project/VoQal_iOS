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
    
    internal let changeNicknameButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 15)
        let image = UIImage(systemName: "pencil", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let coachLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Medium", size: 15)
        label.textColor = .white
        
        return label
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
        addSubview(changeNicknameButton)
        addSubview(coachLabel)
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
            
            changeNicknameButton.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 10),
            changeNicknameButton.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            changeNicknameButton.widthAnchor.constraint(equalToConstant: 20),
            changeNicknameButton.heightAnchor.constraint(equalToConstant: 20),
            
            coachLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            coachLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: 10),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: coachLabel.bottomAnchor, constant: 20),
            
            menuTableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            menuTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            menuTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            menuTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func configure(_ name: String, _ nickname: String, _ coachName: String?) {
        nameLabel.text = name
        nicknameLabel.text = nickname
        if let coachName = coachName {
            coachLabel.text = "with \(coachName) 코치님"
        }
        else {
            coachLabel.text = ""
        }
    }
    
    func updateNicknameLabel(_ text: String) {
        nicknameLabel.text = text
    }
    
}
