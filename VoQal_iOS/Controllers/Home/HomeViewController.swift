//
//  HomeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

struct UserModel: Codable {
    let email: String?
    let nickname: String?
    let name: String?
    let phoneNum: String?
    let role: String?
}

class HomeViewController: BaseViewController {
    private let homeView = HomeView()
    private let homeManager = HomeManager()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home viewDidLoad!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타날 때마다 유저 정보를 불러와 UI를 업데이트합니다.
        handleNotAuthenticated()
    }
    
    
    override func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.loginCompletion = { [weak self] in
            self?.handleLoginSuccess()
        }
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.navigationBar.barTintColor = UIColor(named: "mainBackgroundColor")
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
    }
    
    private func handleNotAuthenticated() {
        guard let accessToken = KeychainHelper.shared.getAccessToken(), !accessToken.isEmpty else {
            showLoginScreen()
            return
        }
        
        homeManager.getUserInform { [weak self] homeModel in
            if let model = homeModel {
                if let successModel = model.successModel {
                    print("User information updated: \(successModel)")
                    
                    if let email = successModel.email,
                       let nickname = successModel.nickname,
                       let name = successModel.name,
                       let phoneNum = successModel.phoneNum,
                       let role = successModel.role{
                        
                        if role == "GUEST" {
                            self?.showLoginScreen()
                            return
                        }
                        
                        let user = UserModel(
                            email: successModel.email,
                            nickname: successModel.nickname,
                            name: successModel.name,
                            phoneNum: successModel.phoneNum,
                            role: successModel.role
                        )
                        
                        UserManager.shared.userModel = user
                        self?.updateUI(with: user)
                    }
                } else if let errorModel = model.errorModel {
                    print("Error Data: \(errorModel)")
                }
            } else {
                print("유저 데이터를 받아오는 데에 실패했습니다.")
            }
        }
    }
    
    private func handleLoginSuccess() {
        // 로그인 성공 후 유저 정보를 다시 로드하고 UI를 업데이트합니다.
        if let user = UserManager.shared.userModel {
            updateUI(with: user)
        }
    }

    func refreshUI() {
            // 유저 정보를 다시 불러와 UI를 업데이트
            if let user = UserManager.shared.userModel {
                updateUI(with: user)
            }
        }

    private func updateUI(with user: UserModel) {
        // 유저 정보를 사용하여 UI를 업데이트합니다.
        // 예: homeView.nicknameLabel.text = user.nickname
        print("update UI!")
    }
}
