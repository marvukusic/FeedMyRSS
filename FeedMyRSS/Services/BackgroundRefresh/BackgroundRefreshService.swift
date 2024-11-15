//
//  BackgroundRefreshService.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 15.11.2024..
//

import BackgroundTasks

enum BackgroundRefreshService {
    static let identifier: String = "vukusic.marko.rssfeed.items.refresh"
    
    static func register(callback: @escaping ()->Void) {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            task.expirationHandler = { task.setTaskCompleted(success: false) }
            
            try? scheduleTask()
            callback()
            task.setTaskCompleted(success: true)
        }
    }
    
    static func scheduleTask() throws {
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60) /// Every hour
        
        try BGTaskScheduler.shared.submit(request)
    }
}
