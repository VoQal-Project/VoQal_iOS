//
//  HomeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

struct UserModel: Codable, Equatable {
    let email: String?
    let nickname: String?
    let name: String?
    let phoneNum: String?
    let role: String?
}

class HomeViewController: BaseViewController {
    private let homeView = HomeView()
    private let homeManager = HomeManager()
    
    private var currentUser: UserModel?
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home viewDidLoad!")
        
        NotificationCenter.default.addObserver(self, selector: #selector(userModelUpdated), name: .userModelUpdated, object: nil)
        print("Notification observer registered")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("home viewWillAppear!")
        
        DispatchQueue.main.async {
            self.updateUserInformationIfNeeded()
        }
        
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Observer 제거하지 않음
        // NotificationCenter.default.removeObserver(self, name: .userModelUpdated, object: nil)
        print("Notification observer will not be removed")
    }
    
    override func showLoginScreen() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            loginVC.loginCompletion = { [weak self] in
                self?.handleLoginSuccess()
            }
            let navigationController = UINavigationController(rootViewController: loginVC)
            navigationController.navigationBar.barTintColor = UIColor(named: "mainBackgroundColor")
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false, completion: nil)
        }
    }
    
    private func updateUserInformationIfNeeded() {
        guard let accessToken = KeychainHelper.shared.getAccessToken(), !accessToken.isEmpty else {
            showLoginScreen()
            return
        }
        
        if UserManager.shared.userModel == nil {
            homeManager.getUserInform { [weak self] homeModel in
                if let model = homeModel {
                    if let successModel = model.successModel {
                        print("User information updated: \(successModel)")
                        
                        if let email = successModel.email,
                           let nickname = successModel.nickname,
                           let name = successModel.name,
                           let phoneNum = successModel.phoneNum,
                           let role = successModel.role {
                            
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
                        }
                    } else if let errorModel = model.errorModel {
                        print("Error Data: \(errorModel)")
                    }
                } else {
                    print("유저 데이터를 받아오는 데에 실패했습니다.")
                }
            }
        }
    }
    
    private func handleLoginSuccess() {
        // 로그인 성공 후 유저 정보를 다시 로드하고 UI를 업데이트합니다.
        print("Handle Login Success")
        updateUserInformationIfNeeded()
    }

    @objc private func userModelUpdated(_ notification: Notification) {
        print(UserManager.shared.userModel)
        if let user = UserManager.shared.userModel {
            print("UserModel updated notification")
            updateUIIfNeeded(with: user)
        }
    }
    
    func refreshUI() {
        // 유저 정보를 다시 불러와 UI를 업데이트
        if let user = UserManager.shared.userModel {
            print("refreshUI - user model exists")
            updateUIIfNeeded(with: user)
        } else {
            print("refreshUI - user model is nil")
        }
    }
    
    private func updateUIIfNeeded(with user: UserModel) {
        // 기존 유저 정보와 비교하여 다를 경우에만 UI를 업데이트합니다.
        if currentUser != user {
            print("Updating UI with new user")
            currentUser = user
            updateUI(with: user)
        } else {
            print("No need to update UI - user is the same")
        }
    }

    private func updateUI(with user: UserModel) {
        // 유저 정보를 사용하여 UI를 업데이트합니다.
        // 예: homeView.nicknameLabel.text = user.nickname
        print("update UI with user: \(user)")
    }
}
