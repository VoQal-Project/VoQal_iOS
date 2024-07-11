//
//  RoleSelectionViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 5/1/24.
//

import UIKit

class RoleSelectionViewController: UIViewController {

    private let roleSelectionView = RoleSelectionView()
    
    override func loadView() {
        view = roleSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddTarget()
    }
    
    private func setAddTarget() {
        roleSelectionView.coachButton.addTarget(self, action: #selector(didTapCoachButton), for: .touchUpInside)
        roleSelectionView.studentButton.addTarget(self, action: #selector(didTapStudentButton), for: .touchUpInside)
    }
    
    @objc private func didTapCoachButton() {
        // api로 코치 선택함을 알려야함 그 뒤 클로저를 통해 아래 함수 처리
        
//            dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapStudentButton() {
        let vc = CoachSelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
