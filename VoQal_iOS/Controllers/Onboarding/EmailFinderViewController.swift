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
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
