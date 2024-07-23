//
//  HomeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class HomeViewController: BaseViewController, MyPageViewDelegate {
    private let homeView = HomeView()
    private let homeManager = HomeManager()
    
    private var currentUser: UserModel?
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home viewDidLoad!")
        homeView.homeViewController = self
        setupNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(userModelUpdated), name: .userModelUpdated, object: nil)
        print("Notification observer registered")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("home viewWillAppear!")
        
        DispatchQueue.main.async {
            self.updateUserInformationIfNeeded()
            
            self.refreshUI()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Observer 제거하지 않음
        // NotificationCenter.default.removeObserver(self, name: .userModelUpdated, object: nil)
        print("Notification observer will not be removed")
    }
    
    override func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
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
        
        print("토큰이 온전합니다. - updateUserInformationIfNeeded")
        
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
                                email: email,
                                nickname: nickname,
                                name: name,
                                phoneNum: phoneNum,
                                role: role
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
            homeView.updateUI(with: user)
        } else {
            print("No need to update UI - user is the same")
        }
    }

    @objc internal func didTapManageStudentBtn() {
        print("학생 관리 탭!")
        let vc = ManageStudentViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "학생 관리"
    }
    
    @objc internal func didTapManageLessonBtn() {
        print("수업 관리 탭!")
    }
    
    func removeTarget() {
        homeView.resetButtonTargets()
        self.currentUser = nil
    }
    
}
