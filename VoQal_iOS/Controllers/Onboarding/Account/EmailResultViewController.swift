//
//  EmailResultViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/28/24.
//

import UIKit

class EmailResultViewController: UIViewController {

    var emailValue: String?
    
    private let emailResultView = EmailResultView()
    
    override func loadView() {
        view = emailResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailResultView.email = emailValue
        
        setupNavigationBar()
        setAddTarget()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setAddTarget() {
        emailResultView.confirmButton.addTarget(self, action: #selector(didTapConfirmBtn), for: .touchUpInside)
    }

    @objc private func didTapConfirmBtn() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
