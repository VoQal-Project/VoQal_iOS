//
//  HomeViewController.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/19.
//

import UIKit
import FirebaseMessaging

class HomeViewController: BaseViewController, MyPageViewDelegate, MessagingDelegate {
    private let homeView = HomeView()
    private let homeManager = HomeManager()
    private let challengeManager = ChallengeManager()
    private let fcmTokenManager = FCMTokenManager()
    
    private var currentUser: UserModel?
    internal var thumbnail: UIImage?
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("home viewDidLoad!")
        homeView.homeViewController = self
        
        setupNavigationBar()
        homeView.updateThumbnail(nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userModelUpdated), name: .userModelUpdated, object: nil)
        print("Notification observer registered")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("home viewWillAppear!")
        
        DispatchQueue.main.async {
            self.updateUserInformationIfNeeded()
            self.refreshUI()
        }
        
        self.thumbnail = nil
        loadLessonSongThumbnail()
        setChallengeBanner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Observer 제거하지 않음
        // NotificationCenter.default.removeObserver(self, name: .userModelUpdated, object: nil)
        print("Notification observer will not be removed")
    }
    
    override func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func showLoginScreen() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            loginVC.loginCompletion = { [weak self] in
                self?.handleLoginSuccess()
            }
            let navigationController = UINavigationController(rootViewController: loginVC)
            navigationController.navigationBar.barTintColor = UIColor(named: "mainBackgroundColor")
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false, completion: nil)
        }
    }
    
    private func updateUserInformationIfNeeded() {
        guard let accessToken = KeychainHelper.shared.getAccessToken(), !accessToken.isEmpty else {
            showLoginScreen()
            return
        }
        
        print("토큰이 온전합니다. - updateUserInformationIfNeeded")
        
        if UserManager.shared.userModel == nil {
            homeManager.getUserInform { [weak self] homeModel in
                guard let self = self else { print("homeVC - updateUserInformationIfNeeded self is nil"); return }
                
                if let model = homeModel {
                    if let successModel = model.successModel {
                        print("User information updated: \(successModel)")
                        let lessonSongUrl = successModel.lessonSongUrl
                        let assignedCoach = successModel.assignedCoach
                        if let email = successModel.email,
                           let nickname = successModel.nickname,
                           let name = successModel.name,
                           let phoneNum = successModel.phoneNum,
                           let memberId = successModel.memberId,
                           let role = successModel.role {
                            
                            if role == "GUEST" {
                                self.showLoginScreen()
                                return
                            }
                            
                            let user = UserModel(
                                memberId: memberId,
                                email: email,
                                nickname: nickname,
                                name: name,
                                phoneNum: phoneNum,
                                role: role,
                                lessonSongUrl: lessonSongUrl,
                                assignedCoach: assignedCoach
                            )
                            
                            UserManager.shared.userModel = user
                            self.sendFCMToken()
                            self.loadLessonSongThumbnail()
                        }
                    } else if let errorModel = model.errorModel {
                        print("Error Data: \(errorModel)")
                    }
                } else {
                    print("유저 데이터를 받아오는 데에 실패했습니다.")
                }
            }
        }
    }
    
    private func handleLoginSuccess() {
        // 로그인 성공 후 유저 정보를 다시 로드하고 UI를 업데이트합니다.
        print("Handle Login Success")
        updateUserInformationIfNeeded()
    }
    
    private func loadLessonSongThumbnail() {
        if let url = UserManager.shared.userModel?.lessonSongUrl {
            homeManager.getLessonSongThumbnail(url) { [weak self] model in
                guard let self = self else { return }
                self.thumbnail = model?.thumbnail
                print("썸네일 저장 완료")
                DispatchQueue.main.async {
                    self.homeView.updateThumbnail(self.thumbnail)
                }
            }
        }
    }

    @objc private func userModelUpdated(_ notification: Notification) {
        
        print(UserManager.shared.userModel)
        if let user = UserManager.shared.userModel {
            print("UserModel updated notification")
            
            updateUIIfNeeded(with: user)
        }
    }
    
    func refreshUI() {
        // 유저 정보를 다시 불러와 UI를 업데이트
        if let user = UserManager.shared.userModel {
            print("refreshUI - user model exists")
            updateUIIfNeeded(with: user)
        } else {
            print("refreshUI - user model is nil")
        }
    }
    
    private func updateUIIfNeeded(with user: UserModel) {
        // 기존 유저 정보와 비교하여 다를 경우에만 UI를 업데이트합니다.
        if currentUser != user {
            print("Updating UI with new user")
            currentUser = user
            homeView.updateUI(with: user)
            homeView.updateThumbnail(self.thumbnail)
        } else {
            print("No need to update UI - user is the same")
        }
    }
    
    private func sendFCMToken() {
        guard let id = UserManager.shared.userModel?.memberId else { print("homeVC - sendFCMToken memberId is nil"); return }
        
        Messaging.messaging().delegate = self
        
        if let fcmToken = Messaging.messaging().fcmToken {
            fcmTokenManager.sendFCMToken(String(id), fcmToken) { [weak self] model in
                guard let self = self, let model = model else { print("sendFCMToken self or model is nil"); return }
                
                if model.status == 200 {
                    print("HomeVC - FCM Token 전송 완료")
                }
                else {
                    print("HomeVC - FCM Token 전송 실패")
                }
            }
        }
        else {
            print("FCMToken 받아오기 실패")
        }
    }
    
    private func setChallengeBanner() {
        challengeManager.fetchKeyword { [weak self] model in
            guard let model = model, let self = self else {
                print("setChallengeBanner - model or self is nil"); return
            }
            
            homeView.setChallengeBannerLabel(model.keyword, model.color)
            homeView.challengeBanner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapChallengeBanner)))
        }
        
    }

    @objc internal func didTapLessonSongButton() {
        let vc = LessonSongWebViewController()
        vc.setLessonSongUrl(UserManager.shared.userModel?.lessonSongUrl)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func didTapManageReservationButton() {
        let vc = MyReservationViewController()
        vc.title = "예약 관리"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func didTapSNSButton() {
        let vc = SNSWebViewController()
        vc.setLessonSongUrl("https://github.com/VoQal-Project")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func didTapManageStudentBtn() {
        print("학생 관리 탭!")
        let vc = ManageStudentViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.title = "학생 관리"
    }
    
    @objc internal func didTapChatBtn() {
        print("담당 코치와의 채팅!")
        let vc = ChatViewController()
        guard let coach = UserManager.shared.userModel?.assignedCoach else { return }
        vc.title = "\(coach) 코치님"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc internal func didTapManageLessonBtn() {
        
        guard let role = UserManager.shared.userModel?.role else { print("userModel에 role이 없습니다."); return }
        
        if role == "STUDENT" {
            print("학생 기준 수업 관리 탭")
            let vc = StudentLessonManageViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if role == "COACH" {
            print("코치 기준 수업 관리 탭")
        }
    }
    
    @objc private func didTapChallengeBanner() {
        if let tabBarVC = self.tabBarController {
            print("탭을 변경합니다.")
            tabBarVC.selectedIndex = 2
        }
        else {
            print("탭바 컨트롤러를 찾지 못했습니다.")
        }
    }
    
    func removeTarget() {
        homeView.resetButtonTargets()
        self.currentUser = nil
    }
    
}
