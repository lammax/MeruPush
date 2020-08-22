//
//  AppDelegate.swift
//  MeruPush
//
//  Created by Mac on 20.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseMessaging
import FirebaseCore
import FirebaseInstanceID

/*
 Name:Push Notification Key
 Key ID:Y29MVHRKBZ
 Services:Apple Push Notifications service (APNs)
 Team ID: Z8JVJD6M2F
 Token: dDR8x4eTSM-ELaK8lhARY1:APA91bFThFfsz4VioVoUEXe_I9hbuVi60OtH3fFcDPYIdfS2c0wxFdeBi8VND3Rw-qI8v_r6t7yXvRbt2MuyFh5DJ5hKDSFOznjjdu8qxk_Mf6DDpOrXr97-HgtvEKr0r_b0BAFleVax
 Remote instance ID token: fVNBzjKpBkLImsLj7X12yC:APA91bGTvd2ILIZDuUy2ZXhJnWTJ8QpSpffC93HaYzUEwVJBGuNQSOzJ0Onh-BDfpXe2jt7RREAKRROg8tuHj3hX-aLTKzdJSfjlikqIH-xNZLQTvn_dPNEBV9dvadKcO5UqkWaOHQ0X
 Device ID: 4950CC3A-6801-4721-A16B-7E8648A53729
 */

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
    
    let settings = CommonSettings.sharedInstance
    fileprivate let viewActionIdentifier = "VIEW_IDENTIFIER"
    fileprivate let viewCategoryIdentifier = "VIEW_CATEGORY"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        getTokenFromServer()
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


    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
              print("Permission granted: \(granted)")
              guard granted else { return }
                
                
                
                self.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            guard settings.authorizationStatus == .authorized else { return }
            
            self.prepareActions()
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func prepareActions() {
        let viewAction = UNNotificationAction(identifier: viewActionIdentifier,
                                              title: "View",
                                              options: [.foreground])
        let viewCategory = UNNotificationCategory(identifier: viewCategoryIdentifier,
                                                  actions: [viewAction],
                                                  intentIdentifiers: [],
                                                  options: [])
        UNUserNotificationCenter.current().setNotificationCategories([viewCategory])
    }
    
    func getTokenFromServer() {
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
            self.settings.pushToken = result.token
            NetManager.putPushToken(token: result.token)
            //self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
          }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict: [String: String] = ["token": fcmToken]
        print(dataDict)
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        PushNotificationManager.doPushNotificationInfo(userInfo: userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    
    let userInfo = response.notification.request.content.userInfo
    
    PushNotificationManager.doPushNotificationInfo(userInfo: userInfo)
    
    completionHandler()
  }
    
    
}
