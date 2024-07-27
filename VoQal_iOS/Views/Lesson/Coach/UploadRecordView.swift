//
//  UploadRecordView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/25/24.
//

import UIKit

class UploadRecordView: BaseView {
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.7
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "mainBackgroundColor")
        view.layer.cornerRadius = 15.0
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let titleField: CustomTextField = {
        let customField = CustomTextField()
        customField.placeholder = "제목을 입력해주세요"
        customField.translatesAutoresizingMaskIntoConstraints = false
        
        return customField
    }()
    
    private let recordFileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-Regular", size: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let completeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.tintColor = .white
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 13)
        button.layer.cornerRadius = 10.0
        button.layer.cornerCurve = .continuous
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let closeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
//        recordFileNameLabel.text = uploadRecordViewController.
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addSubViews() {
        addSubview(dimmedView)
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleField)
        contentView.addSubview(recordFileNameLabel)
        contentView.addSubview(completeButton)
        addSubview(closeButton)
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: dimmedView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: dimmedView.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 300),
            contentView.heightAnchor.constraint(equalToConstant: 220),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            closeButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleField.heightAnchor.constraint(equalToConstant: 40),
            
            recordFileNameLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor, constant: 5),
            recordFileNameLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor, constant: -5),
            recordFileNameLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10),
            
            completeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            completeButton.widthAnchor.constraint(equalToConstant: 70),
            completeButton.heightAnchor.constraint(equalToConstant: 35),
            
        ])
    }
    
    internal func configure(_ fileUrl: URL) {
        recordFileNameLabel.text = "파일명 : \(fileUrl.lastPathComponent)"
    }
    
    @objc private func dismissKeyboard() {
        print("외부 탭")
        endEditing(true)
    }
}
