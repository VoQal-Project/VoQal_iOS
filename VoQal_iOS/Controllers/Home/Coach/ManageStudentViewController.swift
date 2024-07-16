//
//  ManageStudentViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/17/24.
//

import UIKit

class ManageStudentViewController: BaseViewController {

    private let manageStudentView = ManageStudentView()
    
    override func loadView() {
        view = manageStudentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func setAddTarget() {
        
    }
    
}
