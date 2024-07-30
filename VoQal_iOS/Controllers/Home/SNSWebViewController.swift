//
//  SNSWebViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/30/24.
//

import UIKit

class SNSWebViewController: BaseViewController {

    private var lessonSongUrl: String?
    private let snsWebView = SNSWebView()

    override func loadView() {
        view = snsWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = lessonSongUrl {
            snsWebView.setWebViewUrl(url)
        }
        else {
            print("SNSWebViewController - url 로드 실패!")
        }
    }
    
    func setLessonSongUrl(_ url: String?) {
        self.lessonSongUrl = url
    }
    

}
