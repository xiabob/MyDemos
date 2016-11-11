//
//  ViewController.swift
//  UserNotificationsDemo
//
//  Created by xiabob on 16/11/11.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //发送通知消息
    @IBAction func sendNotification(_ sender: AnyObject) {
        //1、创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "我的通知"
        content.body = "这个通知很及时，很好！"
        do {
            let url = Bundle.main.url(forResource: "dog", withExtension: "jpg")
            let attachment = try UNNotificationAttachment(identifier: "imageAttachment", url:url!, options: nil)
            content.attachments = [attachment]
        } catch {
            
        }
        content.categoryIdentifier = kAlertGategory
        
        //2、创建发送触发，用于本地通知
        //在一定时间后触发 UNTimeIntervalNotificationTrigger，在某月某日某时触发UNCalendarNotificationTrigger 以及在用户进入或是离开某个区域时触发 UNLocationNotificationTrigger.对于UNPushNotificationTrigger，这是和远程通知相关(APNS),You do not create instances of this class directly; the system creates them for you.
        // time interval must be at least 60 if repeating
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        //3、创建消息的请求标识符，用于区分不同的消息，后续可以取消、更新消息
        let requestIdentifier = "com.xiabob.UserNotificationsDemo.test1"
        
        //4、创建一个发送请求
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        //5、将请求添加到发送中心，对于requestIdentifier相同的消息则是更新操作
        UNUserNotificationCenter.current().add(request) { (error) in
            if error == nil {
                print("Schedules a local notification:\(requestIdentifier) for delivery\n")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

