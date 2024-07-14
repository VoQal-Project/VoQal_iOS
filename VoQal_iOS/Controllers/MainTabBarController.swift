//
//  MainTabBarController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstNC = UINavigationController.init(rootViewController: HomeViewController())
        let secondNC = UINavigationController.init(rootViewController: ReservationViewController())
        let thirdNC = UINavigationController.init(rootViewController: ChallengeViewController())
        let fourthNC = UINavigationController.init(rootViewController: MyPageViewController())
        
        self.viewControllers = [firstNC,secondNC,thirdNC,fourthNC]
        
        let firstTabBarItem = UITabBarItem(title: "", image: UIImage(named: "home"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "", image: UIImage(named: "reservation"), tag: 1)
        let thirtdTabBarItem = UITabBarItem(title: "", image: UIImage(named: "crown"), tag: 2)
        let fourthTabBarItem = UITabBarItem(title: "", image: UIImage(named: "person"), tag: 3)
        
        firstNC.tabBarItem = firstTabBarItem
        secondNC.tabBarItem = secondTabBarItem
        thirdNC.tabBarItem = thirtdTabBarItem
        fourthNC.tabBarItem = fourthTabBarItem
        
        self.tabBar.backgroundColor = UIColor(named: "bottomBarColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "mainButtonColor")
        self.tabBar.tintColor = UIColor.white
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoleSelectionSuccess), name: NSNotification.Name("RoleSelectionSuccess"), object: nil)
    }
    
    @objc private func handleRoleSelectionSuccess() {
        self.selectedIndex = 0 // 홈 화면으로 전환
    }
    
    func switchToHome() {
        self.selectedIndex = 0
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController,
           let homeVC = navController.viewControllers.first as? HomeViewController {
            homeVC.refreshUI()
        }
    }
    
    deinit {
        // NotificationCenter 알림 수신 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("RoleSelectionSuccess"), object: nil)
    }
}
