//
//  EmailFinderView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/27/24.
//

import UIKit

class EmailFinderView: UIView, UITextFieldDelegate {
    
    internal let contactField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "전화번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .numberPad
        textField.textContentType = .telephoneNumber
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    internal let nameField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "placeholderColor")!])
        textField.backgroundColor = UIColor(named: "bottomBarColor")
        textField.layer.cornerRadius = CGFloat(7.0)
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .namePhonePad
        textField.textContentType = .name
        textField.spellCheckingType = .no
        
        return textField
    }()
    
    internal let findEmailButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("조회", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor(named: "mainButtonColor")
        
        return button
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: "mainBackgroundColor")
        
        setDelegate()
        addSubViews()
        setConstraints()
        
        addGestureRecognizer(tapGesture)
        
        addToolbar(to: contactField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    private func addToolbar(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let nextButton = UIBarButtonItem(title: "다음", style: .done, target: self, action: #selector(didTapNextButton))
        
        toolbar.setItems([flexSpace, nextButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func didTapNextButton() {
        if contactField.isFirstResponder {
            nameField.becomeFirstResponder()
        }
    }
    
    private func setDelegate() {
        contactField.delegate = self
        nameField.delegate = self
    }
    
    private func addSubViews() {
        self.addSubview(contactField)
        self.addSubview(nameField)
        self.addSubview(findEmailButton)
    }
    
    private func setConstraints() {
        
        contactField.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        findEmailButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            contactField.widthAnchor.constraint(equalToConstant: 320),
            contactField.heightAnchor.constraint(equalToConstant: 40),
            contactField.centerXAnchor.constraint(equalTo: centerXAnchor),
            contactField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            
            nameField.widthAnchor.constraint(equalToConstant: 320),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            nameField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameField.topAnchor.constraint(equalTo: contactField.bottomAnchor, constant: 15),
            
            findEmailButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            findEmailButton.widthAnchor.constraint(equalToConstant: 170),
            findEmailButton.heightAnchor.constraint(equalToConstant: 35),
            findEmailButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
        ])
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameField {
            nameField.resignFirstResponder()
        }
        return true
    }
    
}
