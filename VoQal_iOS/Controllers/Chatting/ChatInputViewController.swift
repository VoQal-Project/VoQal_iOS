//
//  ChatInputViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 9/14/24.
//

import UIKit

class ChatInputViewController: BaseViewController {

    private let chatInputView = ChatInputView()
    
    override func loadView() {
        view = chatInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

}
