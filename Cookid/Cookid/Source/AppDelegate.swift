//
//  AppDelegate.swift
//  Cookid
//
//  Created by 박형석 on 2021/07/05.
//

import UIKit
import Firebase
import RealmSwift
import KakaoSDKCommon
import NaverThirdPartyLogin
import AuthenticationServices
import UserNotifications
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase
        FirebaseApp.configure()
      
        // Realm
        let config = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { _, _ in }
        )
        
        Realm.Configuration.defaultConfiguration = config
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Kakao
        KakaoSDKCommon.initSDK(appKey: "e09da44a9b3c91d2106ab8f25300097b")
        
        // Naver
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        instance?.isNaverAppOauthEnable = true
        instance?.isInAppOauthEnable = true
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.serviceUrlScheme = kServiceAppUrlScheme
        instance?.consumerKey = kConsumerKey
        instance?.consumerSecret = kConsumerSecret
        instance?.appName = kServiceAppName
        
        // FCM
        Messaging.messaging().delegate = self
        
        // UserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
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
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("파이어베이스 토큰: \(String(describing: fcmToken))")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
  
        completionHandler()
    }
}
