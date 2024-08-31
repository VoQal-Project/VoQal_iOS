//
//  EditProfileViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/25/24.
//

import UIKit

class EditNicknameViewController: BaseViewController {

    internal var isNicknameVerified = false
    
    private let editNicknameView = EditNicknameView()
    private let editNicknameManager = EditNicknameManager()
    
    
    override func loadView() {
        view = editNicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNicknameView.editNicknameVC = self
        view.backgroundColor = .clear
    }
    
    override func setAddTarget() {
        editNicknameView.nicknameVerifyButton.addTarget(self, action: #selector(didTapNicknameVerifyBtn), for: .touchUpInside)
    }
    
    @objc private func didTapNicknameVerifyBtn() {
        
        if editNicknameView.nicknameVerifyButton.titleLabel!.text == "중복확인" {
            guard let nickname = editNicknameView.nicknameField.text else {
                print("nickname Field로부터 nickname값을 받아오는 데에 실패했습니다.")
                return
            }
            
            if editNicknameView.isNicknameAPICallInProgress || editNicknameView.isNicknameEditingInProgress {
                return
            }
            
            if !ValidationUtility.isValidNickname(nickname) {
                return
            }
            
            editNicknameView.isNicknameAPICallInProgress = true
            editNicknameView.nicknameVerifyButton.isEnabled = false
            
            editNicknameManager.nicknameDuplicateCheck(nickname) { model in
                self.editNicknameView.isNicknameAPICallInProgress = false
                
                if model?.status == 200 {
                    self.isNicknameVerified = true
                    self.editNicknameView.originalNickname = nickname // originNickname 업데이트
                    self.editNicknameView.updateNicknameVerificationButton(isVerified: true)
                    self.editNicknameView.updateNicknameVerifyLabel(true)
                } else if model?.status == 400 {
                    self.isNicknameVerified = false
                    self.editNicknameView.updateNicknameVerificationButton(isVerified: false)
                    self.editNicknameView.updateNicknameVerifyLabel(false)
                }
            }
            
            
            if !self.editNicknameView.isNicknameEditingInProgress {
                self.editNicknameView.nicknameVerifyButton.isEnabled = true
            }
            
        }
        else if editNicknameView.nicknameVerifyButton.titleLabel!.text == "수정" {
            self.editNicknameView.updateNicknameVerificationButton(isVerified: false)
            self.editNicknameView.clearNicknameVerifyLabel()
            self.isNicknameVerified = false
        }
    }

//    @objc private func didTapCompleteButton() {
//        editNicknameManager.editNickname(<#T##id: Int64##Int64#>, completion: <#T##(EditNicknameModel?) -> Void#>)
//    }
    
}
