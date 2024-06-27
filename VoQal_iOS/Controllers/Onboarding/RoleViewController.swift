//
//  RoleViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 5/1/24.
//

import UIKit

class RoleViewController: UIViewController {

    private let roleView = RoleView()
    
    override func loadView() {
        view = roleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
