//
//  AppDelegate.swift
//  UserNotificationsDemo
//
//  Created by xiabob on 16/11/11.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import UserNotifications

let  kAlertGategory = "kAlertGategory"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationHandler = UserNotificationHandler()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //向用户申请通知权限
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if granted {
                print("授权通过")
            }
        }
        
        //set UNUserNotificationCenterDelegate
        notificationCenter.delegate = notificationHandler
        
        //set category action
        self.registerCategory()
        
        //移除所有已发送的通知，取消所有将要发送的通知消息
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    private func registerCategory() {
        let actions: [UNNotificationAction] = {
            let inputAction = UNTextInputNotificationAction(identifier: "action.input", title: "Input", options: [.foreground], textInputButtonTitle: "Send", textInputPlaceholder: "input something to show")
            
            let goodbyeAction = UNNotificationAction(identifier: "action.goodbye", title: "Goodbye", options: [.foreground])
            
            let cancleAction = UNNotificationAction(identifier: "action.cancle", title: "Cancle", options: [.destructive])
            
            return [inputAction, goodbyeAction, cancleAction]
        }()
        
        let category = UNNotificationCategory(identifier: kAlertGategory, actions: actions, intentIdentifiers: [], options: [.customDismissAction])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

}

