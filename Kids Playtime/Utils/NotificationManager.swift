//
//  NotificationManager.swift
//  Kids Playtime
//
//  Created by Krystian Konieczko on 10/06/2024.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    func askForPermissionToSendNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
//                print("Notifications allowed")
            } else if let error {
                print("notofications not allowed: \(error.localizedDescription)")
            }
        }
    }
    
    func removeNotificationFromQueue() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["1"])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["1"])
    }
    
    func createNotification(gameTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Currently playing:"
        content.subtitle = "\(gameTitle)"
        content.sound = UNNotificationSound.default
        

        // show this notification five minutes from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
