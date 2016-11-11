//
//  UserNotificationHandler.swift
//  UserNotificationsDemo
//
//  Created by xiabob on 16/11/11.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import UserNotifications

//遵循协议UNUserNotificationCenterDelegate，处理消息
class UserNotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    //这个代理方法会在用户与你推送的通知(本地、远程)进行交互时被调用，包括用户通过通知打开了你的应用，或者点击或者触发了某个 action
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        center.getNotificationCategories { (categories) in
            for category in categories {
                if category.identifier == kAlertGategory {
                    self.handleAlertGategory(response: response)
                    break
                }
            }
        }
        
        
        //At the end of your implementation, you must call the completionHandler block to let the system know that you are done processing the notification.
        completionHandler()
        print("didReceive")
    }
    
    //应用内将如何展示这个消息通知，也就是现在应用在前台也可以展示了
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
        // 如果不想显示某个通知，可以直接用空 options 调用 completionHandler:
        // completionHandler([])
    }

    
    //
    
    private func handleAlertGategory(response: UNNotificationResponse) {
        var text = ""
        if response.actionIdentifier == "action.input" {
            text = (response as! UNTextInputNotificationResponse).userText
        } else if response.actionIdentifier == "action.goodbye" {
            text = "Goodbye"
        }
        
        if !text.isEmpty {
            let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: false, completion: nil)
        }
    }
}
