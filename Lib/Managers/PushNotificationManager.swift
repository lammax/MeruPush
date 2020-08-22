//
//  PushNotificationManager.swift
//  MeruPush
//
//  Created by Mac on 23.08.2020.
//  Copyright © 2020 Lammax. All rights reserved.
//

import Foundation

class PushNotificationManager {
    
    class func doPushNotificationInfo(userInfo: [AnyHashable: Any]) {
        
        let settings = CommonSettings.sharedInstance
        
        var eventID: String?
        
        print(userInfo)
        
        userInfo.forEach { (key, value) in
            let keyName = key.base as? String
            let value = value as? String
            switch keyName {
            case .some(let s):
                switch s {
                case "notificationEventId":
                    eventID = value
                case "body":
                    settings.bodyText = value ?? ""
                default:
                    break
                }
            case .none:
                break
            }
        }
        
        guard eventID != nil else { fatalError("Wrong json data!") }
        
        let event = Events(eventID: eventID!)
        
        settings.currentScreen = event.screen
    }
    
}
