//
//  RoleSelectionViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 5/1/24.
//

import UIKit

class RoleSelectionViewController: UIViewController {

    private let roleSelectionView = RoleSelectionView()
    private let roleSelectionManager = RoleSelectionManager()
    private weak var mainTabBarController: MainTabBarController?
    
    init(mainTabBarController: MainTabBarController) {
        self.mainTabBarController = mainTabBarController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        roleSelectionManager.setCoach { model in
            guard let model = model else {
                print("코치 설정 api 반환 값으로 모델을 불러내지 못했습니다.")
                return
            }
            if model.status == 200 {
                print("코치 설정 성공!")
                NotificationCenter.default.post(name: NSNotification.Name("RoleSelectionSuccess"), object: nil)
                self.dismiss(animated: true)
            }
            else {
                print("코치 설정 실패")
            }
        }
    }
    
    @objc private func didTapStudentButton() {
        let vc = CoachSelectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
