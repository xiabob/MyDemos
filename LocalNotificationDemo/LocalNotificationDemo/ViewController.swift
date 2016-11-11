//
//  ViewController.swift
//  LocalNotificationDemo
//
//  Created by xiabob on 16/11/8.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(reciveMessage), name: NSNotification.Name(rawValue: "localnotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendNotification(_ sender: AnyObject) {
        let notification = UILocalNotification()
        
        //通知的具体内容
        notification.alertBody = "这是个本地通知，提醒你有新的消息。"
        
        //解锁界面通知下方的标题，对于4s、iOS8而言，是："滑动来+alertAction"
        notification.alertAction = "详情"
        
        //触发通知时播放的声音，默认是nil，没有声音。UILocalNotificationDefaultSoundName是系统默认声音，注意自定义的音乐文件，长度不能超过30s，否则系统会使用默认UILocalNotificationDefaultSoundName。
        notification.soundName = UILocalNotificationDefaultSoundName 
        
        //通知触发的时间
        notification.fireDate = Date(timeIntervalSinceNow: 10)
        
        //时间对应的时区
        notification.timeZone = TimeZone.current
        
        //多长时间重复一次，这里是1分钟触发一次.Note that intervals of less than one minute are not supported. The default value is 0, which means that the system fires the notification once and then discards it.
        notification.repeatInterval = .minute
        
        //公立、中国农历等，当repeatInterval有效的时候
        notification.repeatCalendar = Calendar(identifier: .chinese)
        
//        notification.applicationIconBadgeNumber = 1 //应用图标显示的通知数量
        
        //通知的触发是由系统管理，即使应用没有运行。如果卸载应用之前还有重复触发通知，那么卸载之后，这些通知将不再触发。但是如果重新安装之后，系统将继续触发这些通知,需要使用cancelAllLocalNotifications等方法取消本地通知。
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    @objc private func reciveMessage() {
        let alert = UIAlertController(title: "", message: "消息来了", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: false, completion: nil)
    }

}

