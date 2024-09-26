//
//  EditProfileView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/25/24.
//

import UIKit

class EditNicknameView: BaseView, UITextFieldDelegate {

    weak var editNicknameVC: EditNicknameViewController?
    
    var isNicknameAPICallInProgress = false
    var isNicknameEditingInProgress = false
    
    internal var originalNickname: String?
    
    
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
        label.text = "닉네임 재설정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    internal let nicknameField: TextFieldWithBottomBorder = {
        let textfield = TextFieldWithBottomBorder()
        textfield.backgroundColor = UIColor(named: "mainBackgroundColor")
        textfield.placeholder = "닉네임을 입력해주세요."
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        return textfield
    }()
    
    lazy var nicknameVerifyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "mainButtonColor")
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var nicknameVerifyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 13)
        
        return label
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SUIT-Regular", size: 15)
        label.textColor = .white
        label.text = "닉네임은 공백, 특수문자를 제외하여 2~15자로 입력해주세요."
        label.textAlignment = .center
        label.numberOfLines = .max
        
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
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(tapGesture)
        nicknameField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    @objc private func dismissKeyboard() {
        print("외부 탭")
        endEditing(true)
    }
    
    override func addSubViews() {
        addSubview(dimmedView)
        addSubview(contentView)
        addSubview(closeButton)
        contentView.addSubview(pageTitle)
        contentView.addSubview(nicknameField)
        contentView.addSubview(nicknameVerifyButton)
        contentView.addSubview(nicknameVerifyLabel)
        contentView.addSubview(completeButton)
        contentView.addSubview(noticeLabel)
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
            
            nicknameField.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 50),
            nicknameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            nicknameField.trailingAnchor.constraint(equalTo: nicknameVerifyButton.leadingAnchor, constant: -10),
            nicknameField.heightAnchor.constraint(equalToConstant: 40),
            
            nicknameVerifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            nicknameVerifyButton.topAnchor.constraint(equalTo: nicknameField.topAnchor, constant: 0),
            nicknameVerifyButton.heightAnchor.constraint(equalToConstant: 40),
            nicknameVerifyButton.widthAnchor.constraint(equalToConstant: 70),
            
            nicknameVerifyLabel.leadingAnchor.constraint(equalTo: nicknameField.leadingAnchor),
            nicknameVerifyLabel.trailingAnchor.constraint(equalTo: nicknameField.trailingAnchor, constant: -5),
            nicknameVerifyLabel.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 5),
            
            noticeLabel.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 40),
            noticeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            noticeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            completeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            completeButton.widthAnchor.constraint(equalToConstant: 70),
            completeButton.heightAnchor.constraint(equalToConstant: 35),
            
        ])
    }
    
    func updateNicknameVerificationButton(isVerified: Bool) {
        nicknameVerifyButton.alpha = isVerified ? 0.5 : 1.0
        nicknameVerifyButton.setTitle(isVerified ? "수정" : "중복확인" , for: .normal)
        nicknameField.isEnabled = isVerified ? false : true
    }
    
    func updateNicknameVerifyLabel(_ verified: Bool) {
        if verified {
            self.nicknameVerifyLabel.textColor = UIColor(hexCode: "0A84FF", alpha: 1.0)
            self.nicknameVerifyLabel.text = "사용 가능한 닉네임입니다."
        }
        else {
            self.nicknameVerifyLabel.textColor = UIColor(hexCode: "FF3B30", alpha: 1.0)
            self.nicknameVerifyLabel.text = "닉네임이 중복되었습니다."
        }
    }
    
    func clearNicknameVerifyLabel() {
        self.nicknameVerifyLabel.text = ""
    }
    
    // MARK: - textField Delegate 메서드 정의
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nicknameField {
            isNicknameEditingInProgress = true
            nicknameVerifyButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
        
//        var accountErrorMessage: String = ""
//        var basicInfoErrorMessage: String = ""
        
        // basicInfo 관련 텍스트필드 유효성 검증
        
        if textField == self.nicknameField {
            editNicknameVC?.isNicknameVerified = false
            
            isNicknameEditingInProgress = false
            if !isNicknameAPICallInProgress {
                nicknameVerifyButton.isEnabled = true
            }
            if textField.text != originalNickname {
                editNicknameVC!.isNicknameVerified = false
                updateNicknameVerificationButton(isVerified: false)
            }
        }
    }
    
}
