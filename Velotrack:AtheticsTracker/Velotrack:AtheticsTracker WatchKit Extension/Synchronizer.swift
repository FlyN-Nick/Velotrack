//
//  Synchronizer.swift
//  Velotrack:AtheticsTracker
//
//  Created by Nicholas Assaderaghi on 3/30/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

import WatchKit
import WatchConnectivity

class Synchronizer: NSObject/*, WCSessionDelegate*/
{
    var canReachOtherDevice = false
    var dataThatDidNotSend: [[[Double]]] = Array()
    var communication = WCSession.self
    var hasSetUp = false
    func setUp()
    {
        if (!hasSetUp)
        {
            let session = WCSession.default
            session.delegate = self as? WCSessionDelegate
            session.activate()
            hasSetUp = true
        }
    }
    func receiveData(data: [[Double]])
    {
        // receive and export that data
        setUp()
        if (canConnect())
        {
            communication.sendMessageData(data, replyHandler: nil, errorHandler: nil)
        }
        else
        {
            dataThatDidNotSend.append(data) // temporarily saves data that couldn't send
            // probably alert the user
        }
    }
    func canConnect() -> Bool
    {
        if (canReachOtherDevice == true && WCSession.isSupported())
        {
            return true
        }
        else
        {
            return false
        }
    }
    func sessionReachibilityDidChange(session: WCSession)
    {
        if session.isReachable
        {
            canReachOtherDevice = true
        }
        else
        {
            canReachOtherDevice = false
        }
    }
}
