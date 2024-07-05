//
//  PasswordResetView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/29/24.
//

import UIKit

class PasswordResetView: UIView {

    internal let emailField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.textContentType = .emailAddress
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    internal let newPasswordField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "새 비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.textContentType = .oneTimeCode
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    internal let newPasswordCheckField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "새 비밀번호 확인", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.textContentType = .oneTimeCode
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    internal let passwordResetButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("비밀번호 재설정", for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 11)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(named: "mainButtonColor")
        
        return button
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        addSubViews()
        setConstraints()
        
        addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func addSubViews() {
        addSubview(emailField)
        addSubview(newPasswordField)
        addSubview(newPasswordCheckField)
        addSubview(passwordResetButton)
    }

    private func setConstraints() {
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordCheckField.translatesAutoresizingMaskIntoConstraints = false
        passwordResetButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            emailField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailField.widthAnchor.constraint(equalToConstant: 320),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            
            newPasswordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            newPasswordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            newPasswordField.widthAnchor.constraint(equalToConstant: 320),
            newPasswordField.heightAnchor.constraint(equalToConstant: 40),
            
            newPasswordCheckField.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 15),
            newPasswordCheckField.centerXAnchor.constraint(equalTo: centerXAnchor),
            newPasswordCheckField.widthAnchor.constraint(equalToConstant: 320),
            newPasswordCheckField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordResetButton.topAnchor.constraint(equalTo: newPasswordCheckField.bottomAnchor, constant: 20),
            passwordResetButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordResetButton.widthAnchor.constraint(equalToConstant: 140),
            passwordResetButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
    }
    
}
