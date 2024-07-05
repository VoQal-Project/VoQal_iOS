//
//  EmailResultView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/28/24.
//

import UIKit

class EmailResultView: UIView {
    
    var email: String? {
        didSet {
            if let email = email, !email.isEmpty {
                resultComment.text = "고객님의 정보와 일치하는 이메일입니다."
                resultEmail.text = email
            } else {
                resultComment.text = "고객님의 정보와 일치하는 이메일을 찾을 수 없습니다."
                resultEmail.text = ""
            }
        }
    }
    
    private let resultComment: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.text = ""
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    private let resultEmail: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont(name: "SUIT-Regular", size: 11)
        label.text = ""
        label.textAlignment = .center
        
        return label
    }()
    
    internal let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = CGFloat(10.0)
        button.backgroundColor = UIColor(named: "mainButtonColor")
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("\(resultEmail.text ?? "Empty Email")")
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        addSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    private func addSubViews() {
        addSubview(resultComment)
        addSubview(resultEmail)
        addSubview(confirmButton)
    }
    
    private func setConstraints() {
        
        resultComment.translatesAutoresizingMaskIntoConstraints = false
        resultEmail.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultComment.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultComment.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            resultComment.widthAnchor.constraint(equalToConstant: 300),
            resultComment.heightAnchor.constraint(equalToConstant: 60),
            
            resultEmail.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultEmail.topAnchor.constraint(equalTo: resultComment.bottomAnchor, constant: 20),
            resultEmail.widthAnchor.constraint(equalToConstant: 300),
            resultEmail.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: resultEmail.bottomAnchor, constant: 40),
            confirmButton.widthAnchor.constraint(equalToConstant: 120),
            confirmButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        
        
    }
    
}
