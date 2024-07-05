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
        
    }
    
    @objc private func didTapSignupBtn() {
        
        guard let email = registrationView.emailField.text,
              let nickname = registrationView.nicknameField.text,
              let password = registrationView.passwordField.text,
              let passwordCheck = registrationView.passwordCheckField.text,
              let name = registrationView.nameField.text,
              let contact = registrationView.contactField.text else {
            print("모든 필드를 입력해야 합니다.")
            return
        }
        
        if ValidationUtility.isValidEmail(email) &&
            ValidationUtility.isValidPassword(password) &&
            ValidationUtility.isValidNickname(nickname) &&
            ValidationUtility.isValidName(name) &&
            ValidationUtility.isValidContact(contact) &&
            password == passwordCheck {
            print("아아")
            self.dismiss(animated: true)
            // 회원가입 api 요청 후 클로저 내에 코치or학생 선택 화면으로.
        } else {
            let alert = UIAlertController(title: "회원가입 실패", message: "올바른 정보를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
        
        
        
        
//        print("회원가입 신청 탭")
//        let vc = RoleViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapEmailVerifyBtn(){
        guard let email = registrationView.emailField.text else {
            print("email Field로부터 email값을 받아오는 데에 실패했습니다.")
            return
        }
        
        
        if ValidationUtility.isValidEmail(email) {
            registrationManager.emailDuplicateCheck(email){ model in
                if model?.message == "사용 가능한 이메일 입니다." {
                    self.isEmailVerified = true
                    self.registrationView.updateEmailVerificationButton(isVerified: true)
                }
                else if model?.message == "이미 사용중인 이메일입니다." {
                    self.isEmailVerified = false
                    self.registrationView.updateEmailVerificationButton(isVerified: false)
                }
            }
        } else {
            print("유효한 이메일 형식이 아닙니다.")
        }
    }
    
    @objc private func didTapNicknameVerifyBtn() {
        guard let nickname = registrationView.nicknameField.text else {
            print("nickName Field로부터 nickName값을 받아오는 데에 실패했습니다.")
            return
        }
        
        if ValidationUtility.isValidNickname(nickname){
            registrationManager.nicknameDuplicateCheck(nickname){ model in
                if model?.message == "사용 가능한 닉네임입니다." {
                    self.isNicknameVerified = true
                    self.registrationView.updateNicknameVerificationButton(isVerified: true)
                }
                else if model?.message == "닉네임이 중복되었습니다." {
                    self.isNicknameVerified = false
                    self.registrationView.updateNicknameVerificationButton(isVerified: false)
                }
            }
        } else {
            print("유효한 닉네임 형식이 아닙니다.")
        }
    }
    
    
    
}
