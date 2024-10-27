//
//  AppDelegate.swift
//  VoQal_iOS
//
//  Created by 송규섭 on 2024/04/13.
//

import UIKit
import Firebase
import FirebaseCore
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    private let fcmTokenManager = FCMTokenManager()
    var isUserInChatRoom = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error in notification permission: \(error)")
            }
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
            
        }
        
        UINavigationBar.appearance().tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "mainBackgroundColor")
        appearance.shadowColor = nil
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // 포그라운드에서 푸시 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 앱이 포그라운드에 있을 때 알림을 표시하도록 설정
        if isUserInChatRoom {
            completionHandler([])
        } else {
            completionHandler([.banner, .sound, .badge])
        }
        
    }
    
    // 백그라운드나 포그라운드에서 푸시 알림을 탭했을 때 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // 메시지를 처리하는 로직 추가 (예: 특정 화면으로 이동)
        Messaging.messaging().appDidReceiveMessage(userInfo)

        if let messageId = userInfo["messageId"] as? String {
            print("Received Message ID: \(messageId)")
            // 메시지 ID로 특정 화면으로 이동하는 등의 처리 로직
        }
        
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        
        print("FCMToken: \(fcmToken)")
        
        if let user = UserManager.shared.userModel, let id = user.memberId {
            fcmTokenManager.sendFCMToken(String(id), fcmToken) { [weak self] model in
                guard let self = self, let model = model else { print("Appdelegate messaging - self or model is nil"); return }
                
                if model.status == 200 {
                    print("FCM Token 서버에 전송 성공")
                }
                else {
                    print("FCM Token 서버에 전송 실패")
                }
            }
        } else {
            print("유저가 로그인하지 않았으므로 FCM 토큰을 서버로 보내지 않음")
        }
        
    }
}

