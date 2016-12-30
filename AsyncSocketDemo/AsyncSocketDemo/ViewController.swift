//
//  ViewController.swift
//  AsyncSocketDemo
//
//  Created by xiabob on 16/12/29.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController, GCDAsyncSocketDelegate {
    
    fileprivate lazy var socket: GCDAsyncSocket = {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        return socket
    }()
    
    fileprivate lazy var heartBeatTimer: Timer = {
        let timer = Timer(timeInterval: 10,
                          target: self,
                          selector: #selector(sendHeartBeat),
                          userInfo: nil,
                          repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        return timer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try socket.connect(toHost: "127.0.0.1", onPort: 1024)
            //发送认证?
            let data = "@".data(using: String.Encoding.utf8) ?? Data()
            socket.write(data, withTimeout: -1, tag: -1)
        } catch {
            print("connect error:\(error)")
        }
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let data = "hello ss".data(using: String.Encoding.utf8) ?? Data()
        socket.write(data, withTimeout: -1, tag: 0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //发送心跳，保持长连接
    func sendHeartBeat() {
        print("sendHeartBeat")
        let data = "HeartBeat".data(using: String.Encoding.utf8) ?? Data()
        socket.write(data, withTimeout: -1, tag: -2)
    }

    
    //MARK: - GCDAsyncSocketDelegate
    
    //连接到服务器
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("Connect:\(host):\(port)")
        
        //定期发送心跳
        heartBeatTimer.fire()
    }
    
    //连接失败
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("Disconnect:\(err)")
        
        heartBeatTimer.invalidate()
    }
    
    //发送消息成功之后回调
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        //读取返回的消息
        //使用\r\n和crlfData()将“粘黏”在一起的数据分隔开，便于解析数据。所以服务端发送的消息必须以\r\n结尾。
        socket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: 0)
    }
    
    //读取消息成功后回调
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let result = String(data: data, encoding: String.Encoding.utf8) ?? ""
        print("tag:\(tag) --> client:\(result)")
    }


}

