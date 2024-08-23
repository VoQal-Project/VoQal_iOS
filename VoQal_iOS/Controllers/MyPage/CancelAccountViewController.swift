//
//  CancelAccountViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 8/20/24.
//

import UIKit

class CancelAccountViewController: BaseViewController {
    
    private let cancelAccountView = CancelAccountView()
    private let cancelAccountManager = CancelAccountManager()
    var cancelCompletion: (() -> Void)?
    
    private var isAgreed: Bool = false
    
    override func loadView() {
        view = cancelAccountView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func setAddTarget() {
        cancelAccountView.checkBoxButton.addTarget(self, action: #selector(didTapCheckBox), for: .touchUpInside)
        cancelAccountView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    @objc private func didTapCheckBox() {
        if isAgreed {
            self.isAgreed = false
            cancelAccountView.setIsHiddenCheckMark(true)
        }
        else {
            self.isAgreed = true
            cancelAccountView.setIsHiddenCheckMark(false)
        }
    }
    
    @objc private func didTapCancelButton() {
        
        if isAgreed {
            cancelAccountManager.cancelAccount { model in
                guard let model = model else { print("CancelAccountViewController - model 바인딩 실패"); return }
                
                if model.status == 200 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                        self.cancelCompletion?()
                    }
                }
                else {
                    print("회원탈퇴 실패 - model.status != 200")
                }
            }
        }
        else {
            print("isAgreed: false")
        }
    }
    
}
