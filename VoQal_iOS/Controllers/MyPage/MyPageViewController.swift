//
//  MyPageViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

protocol MyPageViewDelegate: AnyObject {
    func removeTarget()
}

class MyPageViewController: BaseViewController {
    
    private let myPageView = MyPageView()
    var delegate: MyPageViewDelegate?
    
    private let menuTitles = ["문의하기", "알림", "탈퇴하기", "로그아웃"]
    
    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserInformation()
        
        myPageView.menuTableView.dataSource = self
        myPageView.menuTableView.delegate = self
        myPageView.menuTableView.register(MyPageMenuTableViewCell.self, forCellReuseIdentifier: MyPageMenuTableViewCell.identifier)
        
    }
    
    override func setAddTarget() {
        super.setAddTarget()
    }
    
    private func setUserInformation() {
        if let userModel = UserManager.shared.userModel {
            if let name = userModel.name,
               let nickname = userModel.nickname {
                myPageView.configure(name, nickname, "박효신")
            }
        }
    }
    
    private func didTapLogoutButton() {
        
        let alert = UIAlertController(title: "로그아웃하시겠어요?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            KeychainHelper.shared.clearTokens()
            UserManager.shared.deleteUserModel()
            print("after logout: \(UserManager.shared.userModel)")
            self.delegate?.removeTarget()
            self.showLoginScreen()
            self.resetAllNavigationStacks()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: false)
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
    
    private func resetAllNavigationStacks() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let tabBarController = windowScene.windows.first?.rootViewController as? UITabBarController {
            tabBarController.viewControllers?.forEach { viewController in
                if let navigationController = viewController as? UINavigationController {
                    navigationController.popToRootViewController(animated: false)
                }
            }
        }
    }
}

extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMenuTableViewCell.identifier, for: indexPath) as? MyPageMenuTableViewCell else {
            print("myPageViewController - 셀 dequeue 실패")
            return UITableViewCell()
        }
        
        cell.configure(menuTitles[indexPath.row], indexPath.row == 3 ? true : false)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("1번째 셀")
        case 1:
            print("2번째 셀")
        case 2:
            print("3번째 셀")
        case 3:
            print("4번째 셀")
            didTapLogoutButton()
        default:
            print("정의되지 않은 셀")
        }
    }
    
}
