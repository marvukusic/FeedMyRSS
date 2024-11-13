//
//  FeedMyRSSApp.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI
import BackgroundTasks

@main
struct FeedMyRSSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState.shared)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    try? appDelegate.scheduleFeedRefreshBackgroundTask()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        requestNotificationPermission()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "vukusic.marko.rssfeed.items.refresh", using: nil) { task in
            self.handleBackgroundFeedRefresh(task: task)
        }
        return true
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    private func handleBackgroundFeedRefresh(task: BGTask) {
        task.expirationHandler = { task.setTaskCompleted(success: false) }
        
        try? scheduleFeedRefreshBackgroundTask()
        
        DispatchQueue.main.async {
            AppState.shared.shouldRefreshFeed = true
        }
        task.setTaskCompleted(success: true)
    }
    
    func scheduleFeedRefreshBackgroundTask() throws {
        let request = BGAppRefreshTaskRequest(identifier: "vukusic.marko.rssfeed.items.refresh")
        let afterFifteenMinutes = Date(timeIntervalSinceNow: 15 * 60)
        request.earliestBeginDate = afterFifteenMinutes

        try BGTaskScheduler.shared.submit(request)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.banner, .sound])
    }
}
