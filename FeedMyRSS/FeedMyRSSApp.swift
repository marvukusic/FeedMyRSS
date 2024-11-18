//
//  FeedMyRSSApp.swift
//  FeedMyRSS
//
//  Created by Marko Vukušić on 05.11.2024..
//

import SwiftUI

@main
struct FeedMyRSSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState.shared)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    try? BackgroundRefreshService.scheduleTask()
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        requestNotificationPermission()
        BackgroundRefreshService.register(callback: checkForNewItems)
        return true
    }
    
    private func checkForNewItems() {
        DispatchQueue.main.async {
            AppState.shared.checkForNewItems = true
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let path = userInfo["payload"] as? String {
            AppState.shared.navigateToFeedPath = path
        }
        completionHandler()
    }
}
