//
//  PostChallengeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/12/24.
//

import UIKit

class PostChallengeViewController: BaseViewController {

    private let postChallengeView = PostChallengeView()
    
    override func loadView() {
        view = postChallengeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
