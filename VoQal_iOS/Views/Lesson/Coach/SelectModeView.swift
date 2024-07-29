//
//  SelectModeView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/29/24.
//

import UIKit

class SelectModeView: BaseView {
    
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
    
    internal let closeButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 21)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark", withConfiguration: configuration), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let writeLessonNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("수업 일지 작성", for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 15)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    internal let uploadRecordFileButton: UIButton = {
        let button = UIButton()
        button.setTitle("녹음 파일 업로드", for: .normal)
        button.titleLabel?.font = UIFont(name: "SUIT-Regular", size: 15)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "474747", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func addSubViews() {
        addSubview(dimmedView)
        addSubview(contentView)
        addSubview(closeButton)
        contentView.addSubview(separatorLine)
        contentView.addSubview(writeLessonNoteButton)
        contentView.addSubview(uploadRecordFileButton)
    }
    
    override func setConstraints() {
        
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: dimmedView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: dimmedView.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 200),
            contentView.heightAnchor.constraint(equalToConstant: 120),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            closeButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            separatorLine.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            writeLessonNoteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            writeLessonNoteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            writeLessonNoteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            writeLessonNoteButton.bottomAnchor.constraint(equalTo: separatorLine.topAnchor),
            
            uploadRecordFileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uploadRecordFileButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uploadRecordFileButton.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            uploadRecordFileButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
 
    @objc private func dismissKeyboard() {
        print("외부 탭")
        endEditing(true)
    }
    
}
