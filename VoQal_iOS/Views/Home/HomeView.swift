//
//  HomeView.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit

class HomeView: BaseView {
    
    weak var homeViewController: HomeViewController?
    
    private let lessonSongButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15.0
        button.layer.cornerCurve = .continuous
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "bottomBarColor")
        
        return button
    }()
    
    private let manageRequestButton: CustomButtonView = {
        let customButtonView = CustomButtonView()
        customButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        return customButtonView
    }()
    
    private let introLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "SUIT-Regular", size: 25)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(with user: UserModel) {
        
        print("Home UI updated!")
        
        setIntroText(user.name)
        configureButton(user.role)
        
    }
    
    override func addSubViews() {
        addSubview(introLabel)
        addSubview(lessonSongButton)
        addSubview(manageRequestButton)
    }
    
    override func setConstraints() {
        
        NSLayoutConstraint.activate([
            introLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            introLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
            introLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            introLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            lessonSongButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            lessonSongButton.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 35),
            lessonSongButton.widthAnchor.constraint(equalToConstant: 320),
            lessonSongButton.heightAnchor.constraint(equalToConstant: 170),
            
            manageRequestButton.topAnchor.constraint(equalTo: lessonSongButton.bottomAnchor, constant: 50),
            manageRequestButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            manageRequestButton.widthAnchor.constraint(equalToConstant: 58),
            manageRequestButton.heightAnchor.constraint(equalToConstant: 77),
        ])
        
        
        
    }
    
    private func setIntroText(_ name: String?) {
        if let name = name {
            let message = "님,\n오늘 연습할 곡은 무엇인가요?"
            
            // 커스텀 폰트 로드
            let boldFont = UIFont(name: "SUIT-SemiBold", size: 23) ?? UIFont.systemFont(ofSize: 23, weight: .semibold)
            let regularFont = UIFont(name: "SUIT-Regular", size: 23) ?? UIFont.systemFont(ofSize: 23)
            
            // 전체 텍스트를 NSMutableAttributedString으로 생성
            let attributedText = NSMutableAttributedString(string: name, attributes: [
                .font: boldFont // 이름 부분을 굵게 설정
            ])
            
            // 나머지 텍스트 추가
            let normalText = NSAttributedString(string: message, attributes: [
                .font: regularFont // 나머지 부분은 기본 폰트 설정
            ])
            
            // 나머지 텍스트를 추가
            attributedText.append(normalText)
            
            // UILabel에 attributed text 설정
            introLabel.attributedText = attributedText
        }
    }
    
    private func configureButton(_ userRole: String?) {
        print(userRole ?? "userRole이 없는데요?")
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: userRole == "COACH" ? 13 : 20 , weight: .bold, scale: .large)
        let iconName = userRole == "COACH" ? "person.3.fill" : "pencil"
        let icon = UIImage(systemName: iconName, withConfiguration: largeConfig)
        
        if let icon = icon {
            
            manageRequestButton.setIcon(icon)
        }
        
        let title = userRole == "COACH" ? "학생 관리" : "수업 관리"
        manageRequestButton.setTitleLabel(title)
        
        let action = userRole == "COACH" ? #selector(homeViewController?.didTapManageStudentBtn) : #selector(homeViewController?.didTapManageLessonBtn)
        manageRequestButton.addTarget(homeViewController, action: action, for: .touchUpInside)
    }
    
    func resetButtonTargets() {
        print("target 제거 완료")
        manageRequestButton.getButton().removeTarget(nil, action: nil, for: .allEvents)
    }
    
}
