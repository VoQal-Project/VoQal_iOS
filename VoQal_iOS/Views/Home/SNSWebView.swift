//
//  SNSWebView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/30/24.
//

import UIKit
import WebKit

class SNSWebView: BaseView {

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = UIColor(named: "mainBackgroundColor")
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    internal func setWebViewUrl(_ url: String) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func addSubViews() {
        addSubview(webView)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
