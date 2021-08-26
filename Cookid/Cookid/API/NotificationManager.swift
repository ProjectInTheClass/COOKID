//
//  NotificationManager.swift
//  Cookid
//
//  Created by 김동환 on 2021/08/15.
//

import UserNotifications
import UIKit

struct LocalNotification {
    var id: String
    var title: String
    var body: String
}

enum LocalNotificationDurationType {
    case firstDay
    case everyDay
}

class LocalNotificationManager {
    
    static private var notifications = [LocalNotification]()
    
    static func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    
                }
            }
    }
    
    static func addNotification() {
        
        notifications.append(LocalNotification(id: UUID().uuidString, title: "새로운 달입니다!", body: "새로운 가계부 진행시켜 🏃‍♀️"))
        
        notifications.append(LocalNotification(id: UUID().uuidString, title: "오늘은 어떤 음식을 드셨나요?", body: "오늘의 식사기록을 남겨볼까요? 🍽"))
        
    }
    
    static func scheduleNotifications() {
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            for notification in notifications {
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.body
                content.sound = UNNotificationSound.default
                content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
                
                let request: UNNotificationRequest?
                
                switch notification.title {
                case "새로운 달입니다!":
                    var datComp = DateComponents()
                
                    datComp.day = 1
                    datComp.hour = 9
                    let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
                    request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
                default:
                    
                    var dateComponents = DateComponents()
                    
                    dateComponents.hour = 2
                    dateComponents.minute = 10
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
                }
                
                UNUserNotificationCenter.current().add(request!) { error in
                    guard error == nil else { return }
                    print("Scheduling notification with id: \(notification.id)")
                }
            }
        notifications.removeAll()
    }
    
    static func setNotification() {
        requestPermission()
        scheduleNotifications()
        addNotification()
    }
}

// 퍼미션을 받음
// 노티피케이션에 추가함
// 노티피케이션 스케줄링함
