//
//  ChatViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/14/24.
//

import UIKit

class ChatViewController: BaseViewController {

    private let chatView = ChatView()
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

}
