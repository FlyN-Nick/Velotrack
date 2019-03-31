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

    func receiveData(data: [[Double]])
    {
        // receive and save that data
    }
    func checkIfCanConnect() -> Bool
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
