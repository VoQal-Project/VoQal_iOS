//
//  LessonSongWebView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/28/24.
//

import UIKit
import WebKit

class LessonSongWebView: BaseView {

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = UIColor(named: "mainBackgroundColor")
        
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

}
