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
        
    }

}
