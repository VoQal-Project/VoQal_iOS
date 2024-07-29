//
//  SetLessonSongView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 7/27/24.
//

import UIKit

class SetLessonSongView: BaseView {

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
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SUIT-SemiBold", size: 17)
        label.textColor = .white
        label.text = "레슨곡 설정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let artistField: TextFieldWithBottomBorder = {
        let textfield = TextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.placeholder = "가수명을 입력해주세요."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    internal let songTitleField: TextFieldWithBottomBorder = {
        let textfield = TextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.placeholder = "곡명을 입력해주세요."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    internal let urlTitleField: TextFieldWithBottomBorder = {
        let textfield = TextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.placeholder = "곡 URL을 입력해주세요."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
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
        contentView.addSubview(pageTitle)
        contentView.addSubview(artistField)
        contentView.addSubview(songTitleField)
        contentView.addSubview(urlTitleField)
        contentView.addSubview(completeButton)
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
            contentView.heightAnchor.constraint(equalToConstant: 320),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            closeButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            pageTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            artistField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            artistField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            artistField.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 40),
            artistField.heightAnchor.constraint(equalToConstant: 40),
            
            songTitleField.widthAnchor.constraint(equalTo: artistField.widthAnchor),
            songTitleField.trailingAnchor.constraint(equalTo: artistField.trailingAnchor),
            songTitleField.topAnchor.constraint(equalTo: artistField.bottomAnchor, constant: 20),
            songTitleField.heightAnchor.constraint(equalToConstant: 40),
            
            urlTitleField.widthAnchor.constraint(equalTo: songTitleField.widthAnchor),
            urlTitleField.trailingAnchor.constraint(equalTo: songTitleField.trailingAnchor),
            urlTitleField.topAnchor.constraint(equalTo: songTitleField.bottomAnchor, constant: 20),
            urlTitleField.heightAnchor.constraint(equalToConstant: 40),
            
            completeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            completeButton.widthAnchor.constraint(equalToConstant: 70),
            completeButton.heightAnchor.constraint(equalToConstant: 35),
        ])
        
    }
    
    @objc private func dismissKeyboard() {
        print("외부 탭")
        endEditing(true)
    }
    

}

