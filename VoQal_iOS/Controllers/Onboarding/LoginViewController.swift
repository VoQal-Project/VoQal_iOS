//
//  LoginViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/15.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let loginManager = LoginManager()
    
    var loginCompletion : (() -> Void)?
    
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
        
        loginView.emailField.resignFirstResponder()
        loginView.passwordField.resignFirstResponder()
        
        if let email = loginView.emailField.text, let password = loginView.passwordField.text,
           !email.isEmpty && !password.isEmpty {
            if ValidationUtility.isValidEmail(email) && ValidationUtility.isValidPassword(password) {
                print("모두 성공!")
                loginManager.LoginUser(email, password) { result in
                    guard let result = result else {
                        print("로그인 결과를 받아오는 데 실패했습니다.")
                        let alert = UIAlertController(title: "로그인 실패!", message: "로그인에 실패하였습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(alert, animated: true)
                        return
                    }
                    
                    if result.status == 200 {
                        
                        guard let accessToken = result.accessToken, let refreshToken = result.refreshToken else {
                            print("토큰을 받아오는 데 실패했습니다.")
                            let alert = UIAlertController(title: "토큰 오류", message: "토큰을 받아오는 데 실패했습니다.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default))
                            self.present(alert, animated: true)
                            return
                        }
                        
                        KeychainHelper.shared.saveAccessToken(accessToken)
                        KeychainHelper.shared.saveRefreshToken(refreshToken)
                        
                        if result.role == "GUEST" {
                            let roleSettingVC = RoleSelectionViewController(mainTabBarController: MainTabBarController())
                            print("Access Token: \(String(describing: KeychainHelper.shared.getAccessToken()))\nRefresh Token: \(String(describing: KeychainHelper.shared.getRefreshToken()))")
                            self.navigationController?.pushViewController(roleSettingVC, animated: true)
                        }
                        else if result.role == "COACH" {
                            (self.loginCompletion ?? {print("로그인 컴플리션 오류")})()
                            self.dismiss(animated: true)
                        }
                        
                        
                    } else {
                        let alert = UIAlertController(title: "로그인 실패!", message: "로그인에 실패하였습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            } else {
                let alert = UIAlertController(title: "입력 오류", message: "올바른 이메일과 비밀번호를 입력해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "로그인 실패!", message: "이메일 혹은 비밀번호의 값이 비어있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
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
