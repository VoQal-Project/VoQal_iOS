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
        button.imageView?.layer.cornerRadius = 15.0
        button.imageView?.layer.cornerCurve = .continuous
        button.imageView?.contentMode = .scaleAspectFill
        return button
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
    
    private let firstButton: CustomButtonView = {
        let customButtonView = CustomButtonView()
        customButtonView.setIcon(UIImage(systemName: "list.bullet")!)
        customButtonView.setTitleLabel("예약 관리")
        customButtonView.translatesAutoresizingMaskIntoConstraints = false
        return customButtonView
    }()
    
    private let secondButton: CustomButtonView = {
        let customButtonView = CustomButtonView()
        if let icon = UIImage(named: "snsIcon")?.withTintColor(.white) {
            customButtonView.setIcon(icon)
        }
        customButtonView.setSizeForExternalImage()
        customButtonView.setTitleLabel("SNS 연결")
        customButtonView.translatesAutoresizingMaskIntoConstraints = false
        return customButtonView
    }()
    private let thirdButton: CustomButtonView = {
        let customButtonView = CustomButtonView()
        customButtonView.translatesAutoresizingMaskIntoConstraints = false
        return customButtonView
    }()
    
    private let fourthButton: CustomButtonView = {
        let customButtonView = CustomButtonView()
        customButtonView.setIcon(UIImage(systemName: "pencil")!)
        customButtonView.setTitleLabel("수업 관리")
        customButtonView.translatesAutoresizingMaskIntoConstraints = false
        return customButtonView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [firstButton, secondButton, thirdButton, fourthButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(with user: UserModel) {
        print("Home UI updated!")
        setIntroText(user.name)
        configureButtons()
        configureThirdButton(user.role)
    }

    func updateThumbnail(_ thumbnail: UIImage?) {
        if let thumbnail = thumbnail {
            print("updateThumbnail - updated")
            lessonSongButton.setImage(thumbnail, for: .normal)
        }
        else {
            print("updateThumbnail - nil")
            lessonSongButton.setImage(nil, for: .normal)
        }
    }

    override func addSubViews() {
        addSubview(introLabel)
        addSubview(lessonSongButton)
        addSubview(buttonStackView)
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
            
            buttonStackView.topAnchor.constraint(equalTo: lessonSongButton.bottomAnchor, constant: 35),
            buttonStackView.leadingAnchor.constraint(equalTo: lessonSongButton.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: lessonSongButton.trailingAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 77),
        ])
    }

    private func setIntroText(_ name: String?) {
        if let name = name {
            let message = "님,\n오늘 연습할 곡은 무엇인가요?"
            let boldFont = UIFont(name: "SUIT-SemiBold", size: 23) ?? UIFont.systemFont(ofSize: 23, weight: .semibold)
            let regularFont = UIFont(name: "SUIT-Regular", size: 23) ?? UIFont.systemFont(ofSize: 23)
            let attributedText = NSMutableAttributedString(string: name, attributes: [.font: boldFont])
            let normalText = NSAttributedString(string: message, attributes: [.font: regularFont])
            attributedText.append(normalText)
            introLabel.attributedText = attributedText
        }
    }
    
    private func configureButtons() {
        
        self.lessonSongButton.addTarget(homeViewController, action: #selector(homeViewController?.didTapLessonSongButton), for: .touchUpInside)
        self.firstButton.addTarget(homeViewController, action: #selector(homeViewController?.didTapManageReservationButton), for: .touchUpInside)
        self.secondButton.addTarget(homeViewController, action: #selector(homeViewController?.didTapSNSButton), for: .touchUpInside)
        self.fourthButton.addTarget(homeViewController, action: #selector(homeViewController?.didTapManageLessonBtn), for: .touchUpInside)
        
    }

    private func configureThirdButton(_ userRole: String?) {
        print(userRole ?? "userRole이 없는데요?")
        let largeConfig = UIImage.SymbolConfiguration(pointSize: userRole == "COACH" ? 13 : 20, weight: .bold, scale: .large)
        let iconName = userRole == "COACH" ? "person.3.fill" : "ellipsis.bubble"
        let icon = UIImage(systemName: iconName, withConfiguration: largeConfig)
        
        if let icon = icon {
            thirdButton.setIcon(icon)
        }
        
        let title = userRole == "COACH" ? "학생 관리" : "코치님과 채팅"
        thirdButton.setTitleLabel(title)
        
        let action = userRole == "COACH" ? #selector(homeViewController?.didTapManageStudentBtn) : #selector(homeViewController?.didTapChatBtn)
        thirdButton.addTarget(homeViewController, action: action, for: .touchUpInside)
    }

    func resetButtonTargets() {
        print("target 제거 완료")
        firstButton.getButton().removeTarget(nil, action: nil, for: .allEvents)
        secondButton.getButton().removeTarget(nil, action: nil, for: .allEvents)
        thirdButton.getButton().removeTarget(nil, action: nil, for: .allEvents)
        fourthButton.getButton().removeTarget(nil, action: nil, for: .allEvents)
    }
}
