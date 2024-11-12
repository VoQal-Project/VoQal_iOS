//
//  RegistrationViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/15.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    internal var isEmailVerified = false
    internal var isNicknameVerified = false
    
    private let registrationView = RegistrationView()
    
    private let registrationManager = RegistrationManager()
    
    override func loadView() {
        view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationView.registrationVC = self
        setupNavigationBar()
        //        navigationController?.hidesBarsOnSwipe = true
        setAddTarget()
    }
    
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    
    private func setAddTarget() {
        
        registrationView.signupButton.addTarget(self, action: #selector(didTapSignupBtn), for: .touchUpInside)
        registrationView.emailVerifyButton.addTarget(self, action: #selector(didTapEmailVerifyBtn), for: .touchUpInside)
        registrationView.nicknameVerifyButton.addTarget(self, action: #selector(didTapNicknameVerifyBtn), for: .touchUpInside)
        
    }
    
    @objc private func didTapEmailVerifyBtn() {
        if registrationView.emailVerifyButton.titleLabel!.text == "중복확인" {
            guard let email = registrationView.emailField.text else {
                print("email Field로부터 email값을 받아오는 데에 실패했습니다.")
                return
            }
            
            if registrationView.isEmailAPICallInProgress || registrationView.isEmailEditingInProgress {
                return
            }
            
            if !ValidationUtility.isValidEmail(email) {
                return
            }
            
            registrationView.isEmailAPICallInProgress = true
            registrationView.emailVerifyButton.isEnabled = false
            
            registrationManager.emailDuplicateCheck(email) { model in
                self.registrationView.isEmailAPICallInProgress = false
                
                if model?.status == 200 {
                    self.isEmailVerified = true
                    self.registrationView.originalEmail = email // originEmail 업데이트
                    
                    let alert = UIAlertController(title: nil, message: "사용 가능한 이메일입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.registrationView.updateEmailVerificationButton(isVerified: true)
                    }))
                    self.present(alert, animated: true)
                    
                } else if model?.status == 400 {
                    self.isEmailVerified = false
                    
                    let alert = UIAlertController(title: "", message: "이미 생성된 이메일입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.registrationView.updateEmailVerificationButton(isVerified: false)
                    }))
                    self.present(alert, animated: true)
                    
                }
                
                if !self.registrationView.isEmailEditingInProgress {
                    self.registrationView.emailVerifyButton.isEnabled = true
                }
            }
        } else if registrationView.emailVerifyButton.titleLabel!.text == "수정" {
            self.registrationView.updateEmailVerificationButton(isVerified: false)
            self.isEmailVerified = false
        }
    }
    
    // 닉네임 중복 확인 버튼 클릭 처리
    @objc private func didTapNicknameVerifyBtn() {
        
        if registrationView.nicknameVerifyButton.titleLabel!.text == "중복확인" {
            guard let nickname = registrationView.nicknameField.text else {
                print("nickname Field로부터 nickname값을 받아오는 데에 실패했습니다.")
                return
            }
            
            if registrationView.isNicknameAPICallInProgress || registrationView.isNicknameEditingInProgress {
                return
            }
            
            if !ValidationUtility.isValidNickname(nickname) {
                return
            }
            
            registrationView.isNicknameAPICallInProgress = true
            registrationView.nicknameVerifyButton.isEnabled = false
            
            registrationManager.nicknameDuplicateCheck(nickname) { model in
                self.registrationView.isNicknameAPICallInProgress = false
                
                if model?.status == 200 {
                    self.isNicknameVerified = true
                    self.registrationView.originalNickname = nickname // originNickname 업데이트
                    
                    let alert = UIAlertController(title: nil, message: "사용 가능한 닉네임입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.registrationView.updateNicknameVerificationButton(isVerified: true)
                    }))
                    self.present(alert, animated: true)
                    
                } else if model?.status == 400 {
                    self.isNicknameVerified = false
                    
                    let alert = UIAlertController(title: nil, message: "이미 생성된 닉네임입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.registrationView.updateNicknameVerificationButton(isVerified: false)
                    }))
                    self.present(alert, animated: true)
                    
                }
            }
            
            if !self.registrationView.isNicknameEditingInProgress {
                self.registrationView.nicknameVerifyButton.isEnabled = true
            }
            
        }
        else if registrationView.nicknameVerifyButton.titleLabel!.text == "수정" {
            self.registrationView.updateNicknameVerificationButton(isVerified: false)
            self.isNicknameVerified = false
        }
    }
    
    @objc private func didTapSignupBtn() {
        
        guard let email = registrationView.emailField.text,
              let nickname = registrationView.nicknameField.text,
              let password = registrationView.passwordField.text,
              let passwordCheck = registrationView.passwordCheckField.text,
              let name = registrationView.nameField.text,
              let contact = registrationView.contactField.text else {
            print("모든 정보를 입력해야 합니다.")
            return
        }
        
        if validateAllFields(email, password, passwordCheck, nickname, name, contact) {
            print("회원가입 신청 탭")
            
            registrationManager.registerUser(
                email,
                password,
                nickname,
                name,
                contact) { model in
                    if model?.status == 200{
                        print("회원가입 성공")
                        let alert = UIAlertController(title: "회원가입 성공!", message: "로그인 페이지로 이동합니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        self.present(alert, animated: false)
                    }
                    else if model?.status == 400 {
                        print("이미 존재하는 회원입니다.")
                        let alert = UIAlertController(title: "회원가입 실패!", message: "이미 존재하는 회원입니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: false)
                    }
                }
        } else {
            print("회원가입 실패")
        }
        
    }
    
    private func validateAllFields(_ email: String, _ password: String, _ passwordCheck: String, _ nickname: String, _ name: String, _ contact: String) -> Bool {
        var validationErrors = [String]()
        var notVerifiedErrors = [String]()
        let errorMessage: String
        
        
        
        if !ValidationUtility.isValidEmail(email) {
            validationErrors.append("이메일")
        }
        if !ValidationUtility.isValidPassword(password) {
            validationErrors.append("비밀번호")
        }
        if !ValidationUtility.isValidNickname(nickname) {
            validationErrors.append("닉네임")
        }
        if !ValidationUtility.isValidName(name) {
            validationErrors.append("이름")
        }
        if !ValidationUtility.isValidContact(contact) {
            validationErrors.append("연락처")
        }
        if password != passwordCheck {
            validationErrors.append("비밀번호 확인")
        }
        if isEmailVerified == false {
            notVerifiedErrors.append("이메일")
        }
        if isNicknameVerified == false {
            notVerifiedErrors.append("닉네임")
        }
        
        print("이메일 인증 여부 : \(isEmailVerified), 닉네임 인증 여부 : \(isNicknameVerified)")
        
        
        let validationErrorMessage = "올바른 \(validationErrors.joined(separator: ", "))을(를) 입력해주세요."
        let notVerifiedErrorMessage = "\(notVerifiedErrors.joined(separator: ", "))의 중복 검사를 해주세요."
        
        if !validationErrors.isEmpty && notVerifiedErrors.isEmpty {
            errorMessage = validationErrorMessage
        }
        else if validationErrors.isEmpty && !notVerifiedErrors.isEmpty {
            errorMessage = notVerifiedErrorMessage
        }
        else if !validationErrors.isEmpty && !notVerifiedErrors.isEmpty {
            errorMessage = "\(validationErrorMessage)\n\(notVerifiedErrorMessage)"
        }
        else {
            errorMessage = ""
        }
        
        
        if errorMessage.isEmpty {
            return true
        }
        else {
            let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            
            return false
        }
    }
    
}

