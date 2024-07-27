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
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "가수명"
        label.font = UIFont(name: "SUIT-Regular", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let artistField: UITextFieldWithBottomBorder = {
        let textfield = UITextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "곡명"
        label.font = UIFont(name: "SUIT-Regular", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let songTitleField: UITextFieldWithBottomBorder = {
        let textfield = UITextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "주소"
        label.font = UIFont(name: "SUIT-Regular", size: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let urlTitleField: UITextFieldWithBottomBorder = {
        let textfield = UITextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    private let completeButton: UIButton = {
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
        contentView.addSubview(artistLabel)
        contentView.addSubview(artistField)
        contentView.addSubview(songTitleLabel)
        contentView.addSubview(songTitleField)
        contentView.addSubview(urlLabel)
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
            contentView.heightAnchor.constraint(equalToConstant: 250),
            
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            closeButton.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -5),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            artistLabel.widthAnchor.constraint(equalToConstant: 50),
            artistLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            artistLabel.trailingAnchor.constraint(equalTo: artistField.leadingAnchor, constant: -10),
            
            artistField.widthAnchor.constraint(equalToConstant: 190),
            artistField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            artistField.centerYAnchor.constraint(equalTo: artistLabel.centerYAnchor),
            artistField.heightAnchor.constraint(equalToConstant: 40),
            
            songTitleLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 30),
            songTitleLabel.widthAnchor.constraint(equalToConstant: 50),
            songTitleLabel.trailingAnchor.constraint(equalTo: songTitleField.leadingAnchor, constant: -10),
            
            songTitleField.widthAnchor.constraint(equalTo: artistField.widthAnchor),
            songTitleField.trailingAnchor.constraint(equalTo: artistField.trailingAnchor),
            songTitleField.centerYAnchor.constraint(equalTo: songTitleLabel.centerYAnchor),
            songTitleField.heightAnchor.constraint(equalToConstant: 40),
            
            urlLabel.topAnchor.constraint(equalTo: songTitleLabel.bottomAnchor, constant: 30),
            urlLabel.widthAnchor.constraint(equalToConstant: 50),
            urlLabel.trailingAnchor.constraint(equalTo: urlTitleField.leadingAnchor, constant: -10),
            
            urlTitleField.widthAnchor.constraint(equalTo: songTitleField.widthAnchor),
            urlTitleField.trailingAnchor.constraint(equalTo: songTitleField.trailingAnchor),
            urlTitleField.centerYAnchor.constraint(equalTo: urlLabel.centerYAnchor),
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

class UITextFieldWithBottomBorder: UITextField {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomLine)
    }
}
