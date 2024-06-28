//
//  EmailFinderViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/27/24.
//

import UIKit

class EmailFinderViewController: UIViewController {

    private let emailFinderView = EmailFinderView()
    
    override func loadView() {
        view = emailFinderView
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setAddTarget()
    }
    
    private func setAddTarget() {
        emailFinderView.findEmailButton.addTarget(self, action: #selector(didTapfindBtn), for: .touchUpInside)
    }
    
    @objc private func didTapfindBtn() {
        let vc = EmailResultViewController()
        vc.title = "조회 결과"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
