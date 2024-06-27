//
//  RegistrationViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/15.
//

import UIKit

class RegistrationViewController: UIViewController {

    private let registrationView = RegistrationView()
    
    private let registrationManager = RegistrationManager()
    
    override func loadView() {
        view = registrationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        print("회원가입 신청 탭")
        let vc = RoleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func didTapEmailVerifyBtn(){
        guard let email = registrationView.emailField.text else {
            print("email Field로부터 email값을 받아오는 데에 실패했습니다.")
            return
        }
        
        registrationManager.emailDuplicateCheck(email)
    }
    
    @objc private func didTapNicknameVerifyBtn() {
        guard let nickName = registrationView.nicknameField.text else {
            print("nickName Field로부터 nickName값을 받아오는 데에 실패했습니다.")
            return
        }
    }
    
    
}
