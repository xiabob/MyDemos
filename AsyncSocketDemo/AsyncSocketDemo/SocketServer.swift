//
//  SocketServer.swift
//  AsyncSocketDemo
//
//  Created by xiabob on 16/12/29.
//  Copyright © 2016年 xiabob. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class SocketServer: NSObject, GCDAsyncSocketDelegate {
    private lazy var server: GCDAsyncSocket = {
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main)
        return socket
    }()
    
    var sockets = [GCDAsyncSocket]()
    
    func startServer() {
        do {
            try server.accept(onPort: 1024)
        } catch {
            print("server start error:\(error)")
        }
    }
    
    //MARK: - GCDAsyncSocketDelegate
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        sockets.append(newSocket)
        newSocket.readData(withTimeout: -1, tag: 1)
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let result = String(data: data, encoding: String.Encoding.utf8) ?? ""
        if tag == 1 {
            if result != "@" {
                sockets.last?.disconnect()
                sockets.removeLast()
            } else {
                let data = "hello".data(using: String.Encoding.utf8) ?? Data()
                sockets.last?.write(data, withTimeout: -1, tag: 0)
            }
        }
        print("tag:\(tag) --> server:\(result)")
        
        let data = "from server".data(using: String.Encoding.utf8) ?? Data()
        sock.write(data, withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 0)
    }
}
