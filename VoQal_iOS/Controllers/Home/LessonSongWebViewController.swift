//
//  LessonSongWebViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/28/24.
//

import UIKit

class LessonSongWebViewController: BaseViewController {
    
    private let lessonSongWebView = LessonSongWebView()

    override func loadView() {
        view = lessonSongWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

}
