//
//  RoleSelectionButton.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/9/24.
//

import UIKit

class RoleSelectionButton: UIButton {

    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let customLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Regular", size: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(title: String, icon: UIImage) {
        super.init(frame: .zero)
        customImageView.image = icon.withRenderingMode(.alwaysTemplate)
        customImageView.tintColor = .white // 아이콘 색상 설정
        customLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        
        layer.cornerRadius = 10.0
        backgroundColor = UIColor(named: "bottomBarColor")
        layer.borderColor = UIColor(named: "mainButtonColor")?.cgColor
        layer.borderWidth = 1.0
        
        addSubview(customImageView)
        addSubview(customLabel)
        
        // 이미지와 라벨의 레이아웃 설정
        NSLayoutConstraint.activate([
            customImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            customImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -15),
            customImageView.widthAnchor.constraint(equalToConstant: 60),
            customImageView.heightAnchor.constraint(equalToConstant: 60),
            
            customLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            customLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }

}
