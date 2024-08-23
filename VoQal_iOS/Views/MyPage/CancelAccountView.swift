//
//  CancelAccountView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/20/24.
//

import UIKit

class CancelAccountView: BaseView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "appLogo")
        imageView.backgroundColor = UIColor(named: "mainBackgroundColor")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let firstParagraphLabel: UILabel = {
        let label = UILabel()
        label.text = "VoQal 탈퇴 전 확인하세요"
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let secondParagraphLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴 후 7일 간 계정 복구가 가능하며,\n그 후 앱을 더 이상 사용하지 못하게 됩니다.\n모든 데이터는 복구가 불가능합니다."
        label.textColor = .white
        label.numberOfLines = .max
        label.textAlignment = .center
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let checkBoxButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor(hexCode: "D9D9D9", alpha: 1.0).cgColor
        view.layer.borderWidth = 2
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 5

        return view
    }()
    
    private let checkIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = UIColor(hexCode: "D9D9D9", alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "안내사항을 모두 확인하였으며, 이에 동의합니다."
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        
        return view
    }()
    
    internal let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(iconImageView)
        addSubview(firstParagraphLabel)
        addSubview(secondParagraphLabel)
        addSubview(checkBoxButton)
        checkBoxButton.addSubview(checkIcon)
        addSubview(agreementLabel)
        addSubview(separatorLine)
        addSubview(cancelButton)
    }
    
    override func setConstraints() {
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 140),
            iconImageView.widthAnchor.constraint(equalToConstant: 76),
            iconImageView.heightAnchor.constraint(equalToConstant: 76),
            
            firstParagraphLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            firstParagraphLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            secondParagraphLabel.topAnchor.constraint(equalTo: firstParagraphLabel.bottomAnchor, constant: 20),
            secondParagraphLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            agreementLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            agreementLabel.topAnchor.constraint(equalTo: secondParagraphLabel.bottomAnchor, constant: 25),
            
            checkBoxButton.centerYAnchor.constraint(equalTo: agreementLabel.centerYAnchor),
            checkBoxButton.trailingAnchor.constraint(equalTo: agreementLabel.leadingAnchor, constant: -10),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20),
            
            checkIcon.centerXAnchor.constraint(equalTo: checkBoxButton.centerXAnchor),
            checkIcon.centerYAnchor.constraint(equalTo: checkBoxButton.centerYAnchor),
            checkIcon.widthAnchor.constraint(equalToConstant: 17),
            checkIcon.heightAnchor.constraint(equalToConstant: 17),
            
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            separatorLine.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 40),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 110),
            
        ])
    }

    func setIsHiddenCheckMark(_ isHidden: Bool) {
        checkIcon.isHidden = isHidden
    }
    
}
