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

        setupNavigationBar()
    }
    
    override func setAddTarget() {
        
    }
    
    override func setupNavigationBar() {
        
        let navigationButton = UIBarButtonItem(image: UIImage(systemName: "equal")?.withTintColor(.white), style: .done, target: self, action: #selector(didTapRequestListButton))
        
        self.navigationItem.rightBarButtonItem = navigationButton
        
        self.navigationItem.backButtonTitle = ""
        
    }
    
    @objc private func didTapRequestListButton() {
        let vc = RequestListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
