//
//  AppDelegate.swift
//  unofficial-disquiet
//
//  Created by Finny Jakey on 2023/12/04.
//

import Firebase
import FirebaseMessaging
import Foundation

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    @Published var tappedNotification: Bool = false
    @Published var link: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self

        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        return true

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate : MessagingDelegate {
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.banner, .sound, .badge])
    }
    
    // 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        let application = UIApplication.shared
        
        // Foreground
        if application.applicationState == .active {
            link = (userInfo["link"] as! String).encodeUrl()!
            tappedNotification.toggle()
        }
        
        // Background
        if application.applicationState == .inactive {
            link = (userInfo["link"] as! String).encodeUrl()!
            tappedNotification.toggle()
        }
        
        // Terminated
        if application.applicationState == .background {
            link = (userInfo["link"] as! String).encodeUrl()!
            tappedNotification.toggle()
        }

        completionHandler()
    }
}
