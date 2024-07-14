//
//  MyPageView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/14/24.
//

import UIKit

class MyPageView: BaseView {

    internal let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 15)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(logoutButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 130),
            logoutButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}
