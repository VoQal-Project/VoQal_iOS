//
//  PasswordResetViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/29/24.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    private let passwordResetView = PasswordResetView()
    private let passwordResetManager = PasswordResetManager()
    
    override func loadView() {
        view = passwordResetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        setAddTarget()
    }
    
    private func setAddTarget() {
        passwordResetView.passwordResetButton.addTarget(self, action: #selector(didTapPwdResetBtn), for: .touchUpInside)
    }
    
    private func validateFields() -> Bool {
        
        var errorMessages = [String]()
        
        if let email = passwordResetView.emailField.text, !isValidEmail(email){
            errorMessages.append("이메일")
        }
        if let newPassword = passwordResetView.newPasswordField.text, !isValidPassword(newPassword){
            errorMessages.append("비밀번호")
        }
        if let newPasswordCheck = passwordResetView.newPasswordCheckField.text,
           let newPassword = passwordResetView.newPasswordField.text
        {
            if newPassword != newPasswordCheck {
                errorMessages.append("비밀번호 확인")
            }
        }
        
        if !errorMessages.isEmpty {
            let message = errorMessages.joined(separator: ", ")
            let alert = UIAlertController(title: "입력 값 오류", message: "올바른 \(message)를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTest.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[.!@#$%]).{8,15}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    @objc private func didTapPwdResetBtn() {
        
        if validateFields() {
            guard let email = passwordResetView.emailField.text,
                  let password = passwordResetView.newPasswordField.text else { return }
            
            passwordResetManager.resetPassword(email, password) { [weak self] data in
                guard let self = self, let data = data else { return }
                
                if data.message == "성공적으로 변경되었습니다" {
                    let alert = UIAlertController(title: "", message: "비밀번호가 변경되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: false, completion: nil)
                }
                else if data.status == 400 {
                    let alert = UIAlertController(title: "", message: "올바른 형식의 이메일 주소와 비밀번호를 입력해주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
                else if data.status == 404 {
                    let alert = UIAlertController(title: "", message: "존재하지 않는 회원입니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
    }
    
    
}
