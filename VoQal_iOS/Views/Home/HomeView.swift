//
//  HomeView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class HomeView: BaseView {
    
    let userModel: UserModel?
    
    private let introLabel: UILabel = {
        let label = UILabel()
//        label.text = "\(userModel.name)님 "
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubViews() {
        
    }
    
    override func setConstraints() {
        
    }
    
    
    
}
