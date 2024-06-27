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
        
        let firstTabBarItem = UITabBarItem(title: "첫번째", image: UIImage(systemName: "mic"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "두번째", image: UIImage(systemName: "sun.min"), tag: 1)
        let thirtdTabBarItem = UITabBarItem(title: "세번째", image: UIImage(systemName: "moon"), tag: 2)
        let fourthTabBarItem = UITabBarItem(title: "네번째", image: UIImage(systemName: "pencil"), tag: 3)
        
        firstNC.tabBarItem = firstTabBarItem
        secondNC.tabBarItem = secondTabBarItem
        thirdNC.tabBarItem = thirtdTabBarItem
        fourthNC.tabBarItem = fourthTabBarItem
        
        self.tabBar.backgroundColor = UIColor.white
    }
    
    

}
