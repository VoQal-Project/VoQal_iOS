//
//  BaseViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/13/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 토큰 만료 알림 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginScreen), name: .tokenExpired, object: nil)
        
        setAddTarget()
        setupNavigationBar()
    }
    
    @objc func showLoginScreen() {
        // 로그인 창을 표시하는 로직을 여기에 구현합니다.
        print("토큰이 존재하지 않거나 만료되었습니다. 재로그인합니다.")
        let loginViewController = LoginViewController()
        present(UINavigationController(rootViewController: loginViewController), animated: true, completion: nil)
    }
    
    deinit {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self, name: .tokenExpired, object: nil)
    }
    
    internal func setAddTarget() {
        
    }
    
    internal func setupNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.backgroundColor = UIColor(named: "mainBackgroundColor")
        navigationController?.navigationBar.isTranslucent = false // 투명도 끄기
        navigationController?.navigationBar.barTintColor = UIColor(named: "mainBackgroundColor")
    }
}
