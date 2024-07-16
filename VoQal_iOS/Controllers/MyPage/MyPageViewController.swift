//
//  MyPageViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class MyPageViewController: BaseViewController {
    
    private let myPageView = MyPageView()
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func setAddTarget() {
        super.setAddTarget()
        
        myPageView.logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    @objc private func didTapLogoutButton() {
        KeychainHelper.shared.clearTokens()
        UserManager.shared.deleteUserModel()
        print("after logout: \(UserManager.shared.userModel)")
        
        showLoginScreen()
    }
    
    override func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.loginCompletion = { [weak self] in
            self?.handleLoginSuccess()
        }
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.navigationBar.barTintColor = UIColor(named: "mainBackgroundColor")
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func handleLoginSuccess() {
        // 로그인 성공 후 유저 정보를 다시 로드하고 UI를 업데이트합니다.
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.switchToHome()
        }
        dismiss(animated: true)
    }
}
