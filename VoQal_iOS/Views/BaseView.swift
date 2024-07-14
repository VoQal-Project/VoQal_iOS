//
//  BaseView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/14/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(named: "mainBackgroundColor")
        addSubViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func addSubViews() {
        
    }
    
    internal func setConstraints() {
        
    }

}
