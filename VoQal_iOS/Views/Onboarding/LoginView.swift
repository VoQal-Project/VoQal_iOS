//
//  LoginView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/16.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func didTapEmailButton()
    func didTapPasswordButton()
    func didTapSignupButton()
}

class LoginView: UIView {
    
    weak var delegate: LoginViewDelegate?
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appLogo")
        

        return imageView
    }()
    
    private let defaultView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        return view
    }()
    
    private let appName: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont(name: "SUIT-Regular", size: 50.0)
        label.font = UIFont.systemFont(ofSize: 40) // 폰트 사이즈 조정 메서드
        label.textColor = .white
        label.text = "V o Q a l"
        
        
        return label
    }()
    
    let findEmailButton: UIButton = {
        let button = UIButton()
        button.setTitle("이메일 찾기", for: .normal)
        button.titleLabel!.font = UIFont(name: "SUIT-Regular", size: 13)
        
        return button
    }()
    
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
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    internal let passwordField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        textField.isSecureTextEntry = true
        
        
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.layer.cornerRadius = CGFloat(10.0)
        
        return button
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mainButtonColor")
        
        return view
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
            
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
        setStackView()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.endEditing(true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(defaultView)
        self.addSubview(logo)
        self.addSubview(appName)
        self.addSubview(emailField)
        self.addSubview(passwordField)
        self.addSubview(loginButton)
        self.addSubview(divider)
        self.addSubview(bottomStackView)
    }
    
    private func setConstraints() {
        
        defaultView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            defaultView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            defaultView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            defaultView.topAnchor.constraint(equalTo: self.topAnchor),
            defaultView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logo.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            logo.widthAnchor.constraint(equalToConstant: 190),
            logo.heightAnchor.constraint(equalToConstant: 190),
        ])
        
        appName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appName.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: -10),
            appName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 30),
            emailField.widthAnchor.constraint(equalToConstant: 280),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            passwordField.widthAnchor.constraint(equalToConstant: 280),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            divider.widthAnchor.constraint(equalTo: emailField.widthAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bottomStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15),
            bottomStackView.widthAnchor.constraint(equalToConstant: 230),
            bottomStackView.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    //MARK: - 로그인 하단 스택 뷰 설정
    
    private func setStackView() {
        
        let titles = ["이메일 찾기", "비밀번호 찾기", "회원가입"]
        var count = 0
        
        for i in 1...5 {
            if i % 2 == 1 {
                let button = UIButton()
                button.setTitle(titles[count], for: .normal)
                button.tintColor = .white
                button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                
                bottomStackView.addArrangedSubview(button)
                
                count += 1
            }
            else {
                let divider = UIView()
                divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
                divider.backgroundColor = UIColor(hexCode: "979797")
                
                bottomStackView.addArrangedSubview(divider)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
            // Handle button tap
            switch sender.titleLabel?.text {
            case "이메일 찾기":
                delegate?.didTapEmailButton()
            case "비밀번호 찾기":
                delegate?.didTapPasswordButton()
            case "회원가입":
                delegate?.didTapSignupButton()
            default:
                break
            }
        }
}
