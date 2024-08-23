//
//  MyPageViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit
import MessageUI

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
        
        myPageView.menuTableView.dataSource = self
        myPageView.menuTableView.delegate = self
        myPageView.menuTableView.register(MyPageMenuTableViewCell.self, forCellReuseIdentifier: MyPageMenuTableViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInformation()
    }
    
    override func setAddTarget() {
        super.setAddTarget()
    }
    
    private func setUserInformation() {
        if let userModel = UserManager.shared.userModel {
            let assignedCoach = userModel.assignedCoach
            if let name = userModel.name,
               let nickname = userModel.nickname {
                myPageView.configure(name, nickname, assignedCoach)
            }
        }
    }
    
    private func didTapInquiryMailButton() {
        
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            
            let bodyString = """
                                 이곳에 내용을 작성해주세요.
                                 
                                 앱을 이용하시면서 발견된 버그나 전하고 싶은 의견을 전달해주세요.
                                 
                                 
                                 
                                 -------------------
                                 
                                 Device Model : \(self.getDeviceIdentifier())
                                 Device OS : \(UIDevice.current.systemVersion)
                                 App Version : \(self.getCurrentVersion())
                                 
                                 -------------------
                                 """
            
            composeViewController.setToRecipients(["sks565075@gmail.com"])
            composeViewController.setSubject("<VoQal> 문의 및 의견")
            composeViewController.setMessageBody(bodyString, isHTML: false)
            
            self.present(composeViewController, animated: true, completion: nil)
        } else {
            print("메일 보내기 실패")
            let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
                // 앱스토어로 이동하기(Mail)
                if let url = URL(string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            let cancleAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            sendMailErrorAlert.addAction(goAppStoreAction)
            sendMailErrorAlert.addAction(cancleAction)
            self.present(sendMailErrorAlert, animated: true, completion: nil)
        }
        
    }
    
    private func didTapCancelAccountButton() {
        let cancelAccountVC = CancelAccountViewController()
        cancelAccountVC.cancelCompletion = {
            KeychainHelper.shared.clearTokens()
            UserManager.shared.deleteUserModel()
            print("after cancelAccount: \(UserManager.shared.userModel)")
            self.delegate?.removeTarget()
            self.resetAllNavigationStacks()
            self.showLoginScreen()
        }
        navigationController?.pushViewController(cancelAccountVC, animated: true)
        
    }
    
    private func didTapLogoutButton() {
        
        let alert = UIAlertController(title: "로그아웃하시겠어요?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            KeychainHelper.shared.clearTokens()
            UserManager.shared.deleteUserModel()
            print("after logout: \(UserManager.shared.userModel)")
            self.delegate?.removeTarget()
            self.resetAllNavigationStacks()
            self.showLoginScreen()
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
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
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
            didTapInquiryMailButton()
        case 1:
            print("2번째 셀")
        case 2:
            print("3번째 셀")
            didTapCancelAccountButton()
        case 3:
            print("4번째 셀")
            didTapLogoutButton()
        default:
            print("정의되지 않은 셀")
        }
    }
    
}

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        self.dismiss(animated: true, completion: nil)
    }
}
