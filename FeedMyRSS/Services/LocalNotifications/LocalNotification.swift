//
//  LocalNotification.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 13.11.2024.
//

import Foundation
import NotificationCenter

struct LocalNotification {
    let title: String
    let subtitle: String
    
    init(title: String, subtitle: String = "") {
        self.title = title
        self.subtitle = subtitle
    }
    
    func send() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { _ in }
    }
}
