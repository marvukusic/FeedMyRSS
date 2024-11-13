//
//  LocalNotification.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 13.11.2024.
//

import Foundation
import NotificationCenter

struct LocalNotification {
    let id: String
    let title: String
    let subtitle: String
    
    init(id: String = UUID().uuidString, title: String, subtitle: String = "") {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
    
    func send() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { _ in }
    }
}
