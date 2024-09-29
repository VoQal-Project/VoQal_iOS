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

    internal let challengeBanner: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "181818", alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let challengeBannerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = .max
        label.font = UIFont(name: "SUIT-Regular", size: 20)
        
        return label
    }()
    
    private let crownIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "crown")?.withTintColor(UIColor(hexCode: "F9F871", alpha: 1.0))
        
        return imageView
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
        addSubview(challengeBanner)
        challengeBanner.addSubview(challengeBannerLabel)
        challengeBanner.addSubview(crownIcon)
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
            
            challengeBanner.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 50),
            challengeBanner.leadingAnchor.constraint(equalTo: leadingAnchor),
            challengeBanner.trailingAnchor.constraint(equalTo: trailingAnchor),
            challengeBanner.heightAnchor.constraint(equalToConstant: 140),
            
            challengeBannerLabel.leadingAnchor.constraint(equalTo: challengeBanner.leadingAnchor, constant: 40),
            challengeBannerLabel.trailingAnchor.constraint(equalTo: crownIcon.leadingAnchor, constant: -10),
            challengeBannerLabel.centerYAnchor.constraint(equalTo: challengeBanner.centerYAnchor),
            
            crownIcon.trailingAnchor.constraint(equalTo: challengeBanner.trailingAnchor, constant: -40),
            crownIcon.widthAnchor.constraint(equalToConstant: 57),
            crownIcon.heightAnchor.constraint(equalToConstant: 60),
            crownIcon.centerYAnchor.constraint(equalTo: challengeBanner.centerYAnchor),
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
    
    internal func setChallengeBannerLabel(_ keyword: String, _ color: String) {
        let firstLine = "오늘의 키워드는 \(keyword)입니다.\n"
        let secondLine = "연상되는 노래를 불러보아요!"
        
        // 폰트 설정
        let largeFont = UIFont(name: "SUIT-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium)
        let smallFont = UIFont(name: "SUIT-Medium", size: 15) ?? UIFont.systemFont(ofSize: 23)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        // 첫 번째 라인에 대한 NSMutableAttributedString 생성
        let attributedText = NSMutableAttributedString(string: firstLine, attributes: [.font: largeFont, .paragraphStyle: paragraphStyle])
        
        // keyword에만 색상을 적용
        if let keywordRange = firstLine.range(of: keyword) {
            let nsRange = NSRange(keywordRange, in: firstLine)
            let keywordColor = UIColor(hexCode: color, alpha: 1.0)
            attributedText.addAttribute(.foregroundColor, value: keywordColor, range: nsRange)
        }
        
        // 두 번째 라인을 NSAttributedString으로 추가
        let normalText = NSAttributedString(string: secondLine, attributes: [.font: smallFont, .paragraphStyle: paragraphStyle])
        attributedText.append(normalText)
        
        // 라벨에 최종 attributedText 적용
        challengeBannerLabel.attributedText = attributedText
    }}
