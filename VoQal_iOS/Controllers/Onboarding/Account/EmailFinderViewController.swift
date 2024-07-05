//
//  EmailFinderViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 6/27/24.
//

import UIKit

class EmailFinderViewController: UIViewController {

    private let emailFinderView = EmailFinderView()
    private let emailFinderManager = EmailFinderManager()
    
    override func loadView() {
        view = emailFinderView
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setAddTarget()
    }
    
    private func setAddTarget() {
        emailFinderView.findEmailButton.addTarget(self, action: #selector(didTapfindBtn), for: .touchUpInside)
    }
    
    private func validateFields() -> Bool {
        var errorMessages = [String]()
        
        if let contact = emailFinderView.contactField.text {
            if contact.isEmpty {
                errorMessages.append("전화번호")
            } else if contact.count != 11 {
                errorMessages.append("전화번호 (11자리 숫자)")
            }
        }
        
        if let name = emailFinderView.nameField.text {
            if name.isEmpty || name.count < 2 || name.count > 15{
                errorMessages.append("이름")
            }
        }
        
        if !errorMessages.isEmpty {
            let message = errorMessages.joined(separator: ", ")
            let alert = UIAlertController(title: "입력 값 오류", message: "올바른 \(message)를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
            
            return false
        }
        
        return true
    }
    
    @objc private func didTapfindBtn() {
        
        if validateFields() {
            guard let contact = emailFinderView.contactField.text,
                  let name = emailFinderView.nameField.text else { return }
            
            emailFinderManager.findEmail(contact, name) { [weak self] model in
                guard let self = self, let model = model else { return }
                
                let vc = EmailResultViewController()
                vc.title = "조회 결과"
                vc.emailValue = model.email
                
                self.navigationController?.pushViewController(vc, animated: true)
        }
        
        }
    }
    
}
