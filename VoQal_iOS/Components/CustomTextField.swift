//
//  CustomTextField.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/24/24.
//

import UIKit

class CustomTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // 공통 스타일 설정
        self.borderStyle = .roundedRect
        self.textColor = .white
        self.backgroundColor = UIColor(hexCode: "111111")
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "mainButtonColor")!.cgColor
        self.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")])
        self.font = UIFont(name: "SUIT-Regular", size: 16)
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        self.leftViewMode = .always
    }
}
