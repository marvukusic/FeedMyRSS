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
    let payload: String
    
    init(title: String, subtitle: String = "", payload: String) {
        self.title = title
        self.subtitle = subtitle
        self.payload = payload
    }
    
    func send() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = .default        
        content.userInfo = ["payload": payload]
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { _ in }
    }
}
