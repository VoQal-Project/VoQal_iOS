//
//  LoginViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/15.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        setAddTarget()
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    private func setupLayout() {
        
    }
    
    private func setAddTarget() {
        loginView.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    @objc private func didTapLoginButton() {
        print("로그인 버튼 탭!")
        
        if let email = loginView.emailField.text, let password = loginView.passwordField.text,
           !email.isEmpty && !password.isEmpty {
            if isValidEmail(id: email) && isValidPassword(pwd: password) {
                print("모두 성공!")
                dismiss(animated: false) // 로그인 네트워킹 메서드 구현해야할 자리
            } else {
                print("error: 이메일 혹은 패스워드 값의 유효성 검증에 실패하였습니다.")
            }
            print("NULL 값은 성공함")
        } else {
            print("error: 이메일 혹은 패스워드의 값이 비어있습니다.")
        }
    }
    
    // 아이디 형식 검사
    private func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
    
    // 비밀번호 형식 검사
    private func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,15}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
    
}

extension LoginViewController: LoginViewDelegate {
    func didTapEmailButton() {
        let vc = EmailFinderViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.title = "이메일 찾기"
        print("delegate - didTapEmail")
    }
    
    func didTapPasswordButton() {
        print("delegate - didTapPwd")
        let vc = PasswordResetViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        vc.title = "비밀번호 재설정"
    }
    
    func didTapSignupButton() {
        let vc = RegistrationViewController()
        vc.title = "회원가입"
        self.navigationController?.pushViewController(vc, animated: true)
        
        print("회원가입 버튼 탭")
    }
}
