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
    
    internal var editNicknameCompletion: (() -> Void)?
    
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
        editNicknameView.completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        editNicknameView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }
    
    @objc private func didTapCloseButton() {
        self.dismiss(animated: false)
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

    @objc private func didTapCompleteButton() {
        guard let memberId = UserManager.shared.userModel?.memberId else {
            print("userModel.memberId is nil입니다.")
            return
        }
        
        guard let nickname = editNicknameView.nicknameField.text else {
            print("editNicknameView.nicknameField.text is nil")
            return
        }
        
        editNicknameManager.editNickname(Int64(memberId), nickname) { [weak self] model in
            guard let model = model else {
                print("editNickname - model is nil입니다.")
                return
            }
            
            if model.status == 200 {
                let alert = UIAlertController(title: "변경 완료", message: "닉네임이 변경되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self?.editNicknameCompletion?()
                    self?.dismiss(animated: true)
                }))
                self?.present(alert, animated: false)
            }
            else {
                let alert = UIAlertController(title: "변경 실패", message: "닉네임 변경에 실패했습니다.\n다시 시도해주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: false)
            }
        }
    }
    
}
