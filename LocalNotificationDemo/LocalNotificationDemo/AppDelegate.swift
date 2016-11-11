//
//  AppDelegate.swift
//  LocalNotificationDemo
//
//  Created by xiabob on 16/11/8.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //ios8后，需要添加这个注册，才能得到授权
        let type = UIUserNotificationType.alert.union(.badge).union(.sound)
        let setting = UIUserNotificationSettings(types: type, categories: nil)
        application.registerUserNotificationSettings(setting)
        
        application.cancelAllLocalNotifications()  //取消之前设置的所有通知
        application.applicationIconBadgeNumber = 0 //这个值如果没有设置0，即使卸载应用再重新安装，图标显示的还是这个值
        
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
    
    
    //MARK: - notification
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        NotificationCenter.default.post(name: NSNotification.Name("localnotification"), object: nil)
        
        
        print("didReceive LocalNotification:\(Date())")
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("didRegister")
    }

    
}

