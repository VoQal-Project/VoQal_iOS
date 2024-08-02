//
//  CustomButtonView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/16/24.
//

import UIKit

class CustomButtonView: UIView {
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10.0
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "bottomBarColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "SUIT-Regular", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var iconImageViewWidthConstraint: NSLayoutConstraint?
    private var iconImageViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(button)
        button.addSubview(iconImageView)
        addSubview(label)
        
        iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 37)
        iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 37)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 58),
            button.heightAnchor.constraint(equalToConstant: 58),
            
            iconImageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageViewWidthConstraint!,
            iconImageViewHeightConstraint!,
            
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    func setIcon(_ icon: UIImage) {
        iconImageView.image = icon
    }
    
    func setTitleLabel(_ title: String) {
        label.text = title
    }
    
    func getButton() -> UIButton {
        return button
    }
    
    func setSizeForExternalImage() {
        // 기존 제약 조건 해제
        iconImageViewWidthConstraint?.isActive = false
        iconImageViewHeightConstraint?.isActive = false
        
        // 새로운 제약 조건 설정
        iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 27)
        iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 27)
        
        // 새로운 제약 조건 활성화
        iconImageViewWidthConstraint?.isActive = true
        iconImageViewHeightConstraint?.isActive = true
    }
}
