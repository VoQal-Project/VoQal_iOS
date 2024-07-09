//
//  RegistrationView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/16.
//

import UIKit

class RegistrationView: UIView, UITextFieldDelegate {
    
    weak var registrationVC: RegistrationViewController?
    
    var isEmailAPICallInProgress = false
    var isEmailEditingInProgress = false
    var isNicknameAPICallInProgress = false
    var isNicknameEditingInProgress = false
    let emailDispatchGroup = DispatchGroup()
    let nicknameDispatchGroup = DispatchGroup()
    
    internal var originalEmail: String?
    internal var originalNickname: String?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let nicknameView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let emailView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    internal let nicknameField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.spellCheckingType = .no
        
        return textField
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
        textField.textContentType = .emailAddress
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    lazy var nicknameVerifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 7
        
        
        return button
    }()
    
    lazy var emailVerifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    internal let nameField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
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
        textField.keyboardType = .default
        textField.textContentType = .oneTimeCode
        textField.spellCheckingType = .no
        textField.clearsOnBeginEditing = false
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    internal let passwordCheckField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "비밀번호확인", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
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
    
    private let infoLabel: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = "비밀번호는 영문 대소문자, 숫자, 특수문자(.!@#$%)를 혼합하여 8~15자로 입력해주세요."
        infoLabel.textColor = .white
        infoLabel.numberOfLines = .max
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return infoLabel
    }()
    
    private let iconImageView: UIImageView = {
        // 아이콘 이미지 뷰 생성 및 설정
        let iconImageView = UIImageView(image: UIImage(systemName: "info.circle.fill"))
        iconImageView.tintColor = UIColor.lightGray
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return iconImageView
    }()
    
    
    private let accountCheckInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    internal let contactField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "연락처", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    private let basicCheckInfo: UILabel = {
        let infoLabel = UILabel()
        infoLabel.text = ""
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 5
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        return infoLabel
    }()
    
    lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
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
        
        setDelegate()
        setCustomView()
        addSubViews()
        setConstraints()
        
        addGestureRecognizer(tapGesture)
        
        emailVerifyButton.isEnabled = true
        nicknameVerifyButton.isEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        emailField.delegate = self
        passwordField.delegate = self
        passwordCheckField.delegate = self
        nicknameField.delegate = self
        nameField.delegate = self
        contactField.delegate = self
    }
    
    private func addSubViews() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailView)
        contentView.addSubview(passwordField)
        contentView.addSubview(passwordCheckField)
        contentView.addSubview(accountCheckInfoView)
        contentView.addSubview(nicknameView)
        contentView.addSubview(nameField)
        contentView.addSubview(contactField)
        contentView.addSubview(basicCheckInfo)
        contentView.addSubview(signupButton)
    }
    
    private func setConstraints() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        emailView.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckField.translatesAutoresizingMaskIntoConstraints = false
        accountCheckInfoView.translatesAutoresizingMaskIntoConstraints = false
        nicknameView.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        contactField.translatesAutoresizingMaskIntoConstraints = false
        basicCheckInfo.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            emailView.widthAnchor.constraint(equalToConstant: 320),
            emailView.heightAnchor.constraint(equalToConstant: 40),
            emailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            emailView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            passwordField.widthAnchor.constraint(equalTo: emailView.widthAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 15),
            passwordField.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            passwordCheckField.widthAnchor.constraint(equalTo: emailView.widthAnchor),
            passwordCheckField.heightAnchor.constraint(equalToConstant: 40),
            passwordCheckField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 15),
            passwordCheckField.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            accountCheckInfoView.leadingAnchor.constraint(equalTo: emailView.leadingAnchor),
            accountCheckInfoView.trailingAnchor.constraint(equalTo: emailView.trailingAnchor),
            accountCheckInfoView.topAnchor.constraint(equalTo: passwordCheckField.bottomAnchor, constant: 15),
            
            nicknameView.widthAnchor.constraint(equalToConstant: 320),
            nicknameView.heightAnchor.constraint(equalToConstant: 40),
            nicknameView.topAnchor.constraint(equalTo: accountCheckInfoView.bottomAnchor, constant: 15),
            nicknameView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameField.topAnchor.constraint(equalTo: nicknameView.bottomAnchor, constant: 15),
            nameField.widthAnchor.constraint(equalToConstant: 320),
            nameField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            contactField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor),
            contactField.trailingAnchor.constraint(equalTo: emailView.trailingAnchor),
            contactField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 15),
            contactField.heightAnchor.constraint(equalToConstant: 40),
            
            basicCheckInfo.leadingAnchor.constraint(equalTo: emailView.leadingAnchor),
            basicCheckInfo.trailingAnchor.constraint(equalTo: emailView.trailingAnchor),
            basicCheckInfo.topAnchor.constraint(equalTo: contactField.bottomAnchor, constant: 15),
            
            signupButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: basicCheckInfo.bottomAnchor, constant: 30),
            signupButton.widthAnchor.constraint(equalToConstant: 200),
            signupButton.heightAnchor.constraint(equalToConstant: 35),
            
            contentView.bottomAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 30)
            
        ])
        
    }
    
    private func setCustomView() {
        nicknameView.addSubview(nicknameField)
        nicknameView.addSubview(nicknameVerifyButton)
        
        nicknameField.translatesAutoresizingMaskIntoConstraints = false
        nicknameVerifyButton.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameField.widthAnchor.constraint(equalToConstant: 240).isActive = true
        nicknameField.leadingAnchor.constraint(equalTo: nicknameView.leadingAnchor).isActive = true
        nicknameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nicknameField.centerYAnchor.constraint(equalTo: nicknameView.centerYAnchor).isActive = true
        
        nicknameVerifyButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        nicknameVerifyButton.leadingAnchor.constraint(equalTo: nicknameField.trailingAnchor, constant: 10).isActive = true
        nicknameVerifyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nicknameVerifyButton.centerYAnchor.constraint(equalTo: nicknameView.centerYAnchor).isActive = true
        
        emailView.addSubview(emailField)
        emailView.addSubview(emailVerifyButton)
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailVerifyButton.translatesAutoresizingMaskIntoConstraints = false
        
        emailField.widthAnchor.constraint(equalToConstant: 240).isActive = true
        emailField.leadingAnchor.constraint(equalTo: emailView.leadingAnchor).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailField.centerYAnchor.constraint(equalTo: emailView.centerYAnchor).isActive = true
        
        emailVerifyButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        emailVerifyButton.leadingAnchor.constraint(equalTo: emailField.trailingAnchor, constant: 10).isActive = true
        emailVerifyButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailVerifyButton.centerYAnchor.constraint(equalTo: emailView.centerYAnchor).isActive = true
        
        accountCheckInfoView.addSubview(iconImageView)
        accountCheckInfoView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: accountCheckInfoView.leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: accountCheckInfoView.topAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20), // 가로 20, 세로 20을 예시로 사용
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            infoLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8), // 아이콘과 8pt의 간격
            infoLabel.trailingAnchor.constraint(equalTo: accountCheckInfoView.trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: accountCheckInfoView.topAnchor), // 라벨을 아이콘의 세로 중앙에 위치시킴
            
            accountCheckInfoView.heightAnchor.constraint(equalTo: infoLabel.heightAnchor)
        ])
        
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    func updateEmailVerificationButton(isVerified: Bool) {
        emailVerifyButton.alpha = isVerified ? 0.5 : 1.0
        emailVerifyButton.setTitle(isVerified ? "수정" : "중복확인" , for: .normal)
        emailField.isEnabled = isVerified ? false : true
    }
    
    func updateNicknameVerificationButton(isVerified: Bool) {
        nicknameVerifyButton.alpha = isVerified ? 0.5 : 1.0
        nicknameVerifyButton.setTitle(isVerified ? "수정" : "중복확인" , for: .normal)
        nicknameField.isEnabled = isVerified ? false : true
    }
    
    
    // MARK: - 각 텍스트필드 섹션에 대한 유효성 검증
    var accountErrorMessages: [UITextField: String] = [:]
    
    var basicInfoErrorMessages: [UITextField: String] = [:]
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        
        iconImageView.isHidden = true
        
        infoLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor).isActive = true
        
        
        var accountErrorMessage: String = ""
        var basicInfoErrorMessage: String = ""
        
        // account 관련 텍스트필드 유효성 검증
        if let email = textField.text, textField == self.emailField {
            
            if !ValidationUtility.isValidEmail(email) {
                accountErrorMessage = "- 이메일 주소가 정확한지 확인해 주세요."
            }
            
            isEmailEditingInProgress = false
            if !isEmailAPICallInProgress {
                emailVerifyButton.isEnabled = true
            }
            if textField.text != originalEmail {
                registrationVC!.isEmailVerified = false
                updateEmailVerificationButton(isVerified: false)
            }
        }
        
        if textField == self.passwordField {
            if let password = passwordField.text, !ValidationUtility.isValidPassword(password){
                accountErrorMessage = "- 비밀번호는 영문 대소문자, 숫자, 특수문자(.!@#$%)를 혼합하여 8~15자로 입력해주세요."
            }
        }
        
        if textField == self.passwordCheckField {
            if let password = self.passwordField.text, let passwordCheck = textField.text, password != passwordCheck {
                accountErrorMessage = "- 비밀번호가 일치하지 않습니다."
            }
        }
        
        // basicInfo 관련 텍스트필드 유효성 검증
        
        if textField == self.nicknameField {
            registrationVC?.isNicknameVerified = false
            if let nickname = nicknameField.text, !ValidationUtility.isValidNickname(nickname){
                basicInfoErrorMessage = "- 닉네임은 공백, 특수문자를 제외하여 3~15자로 입력해주세요."
            }
            
            isNicknameEditingInProgress = false
            if !isNicknameAPICallInProgress {
                nicknameVerifyButton.isEnabled = true
            }
            if textField.text != originalNickname {
                registrationVC!.isNicknameVerified = false
                updateNicknameVerificationButton(isVerified: false)
            }
        }
        
        if textField == self.nameField {
            if let name = nameField.text, !ValidationUtility.isValidName(name){
                basicInfoErrorMessage = "- 이름의 형식이 올바르지 않습니다.(공백을 제외한 2~20자 이내)"
            }
        }
        
        if textField == self.contactField {
            if let contact = contactField.text, !ValidationUtility.isValidContact(contact){
                basicInfoErrorMessage = "- 연락처의 형식이 올바르지 않습니다.(- 제외, 010으로 시작하는 11자리 번호)"
            }
        }
        
        // 오류 메시지가 있는 경우 딕셔너리에 저장합니다.
        if !accountErrorMessage.isEmpty {
            accountErrorMessages[textField] = accountErrorMessage
        } else {
            // 오류 메시지가 없는 경우 딕셔너리에서 해당 필드의 오류 메시지를 삭제합니다.
            accountErrorMessages.removeValue(forKey: textField)
        }
        
        if !basicInfoErrorMessage.isEmpty {
            basicInfoErrorMessages[textField] = basicInfoErrorMessage
        } else {
            basicInfoErrorMessages.removeValue(forKey: textField)
        }
        
        // 모든 필드의 오류 메시지를 모아서 하나의 문자열로 만듭니다.
        let accountCombinedErrorMessage = accountErrorMessages.values.joined(separator: "\n")
        
        let basicInfoCombinedErrorMessage = basicInfoErrorMessages.values.joined(separator: "\n")
        
        // 오류 메시지 라벨에 출력합니다.
        infoLabel.text = accountCombinedErrorMessage
        infoLabel.textColor = UIColor(named: "errorColor")
        
        basicCheckInfo.text = basicInfoCombinedErrorMessage
        basicCheckInfo.textColor = UIColor(named: "errorColor")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField {
            isEmailEditingInProgress = true
            emailVerifyButton.isEnabled = false
        } else if textField == nicknameField {
            isNicknameEditingInProgress = true
            nicknameVerifyButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailField {
            emailField.resignFirstResponder()
        }
        else if textField == self.passwordField {
            passwordCheckField.becomeFirstResponder()
        }
        else if textField == self.passwordCheckField {
            nicknameField.becomeFirstResponder()
        }
        else if textField == self.nicknameField {
            nicknameField.resignFirstResponder()
        }
        else if textField == self.nameField {
            contactField.becomeFirstResponder()
        }
        return true
    }
    
}




