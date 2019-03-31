//
//  Synchronizer.swift
//  Velotrack:AtheticsTracker
//
//  Created by Nicholas Assaderaghi on 3/30/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

import WatchKit
import WatchConnectivity
import HealthKit

class Synchronizer: NSObject/*, WCSessionDelegate*/
{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    
    var canReachOtherDevice = false
    var dataThatDidNotSend: [[[[Double]]]] = Array() // yAy FoUr DiMeNsIoNaL aRrAyS
    var heartRateThatDidNotSend: [HKQuantity] = Array()
    var communication = WCSession.self
    var hasSetUp = false
    
    func setUp()
    {
        if (!hasSetUp)
        {
            let session = WCSession.default
            session.delegate = self as! WCSessionDelegate
            session.activate()
            hasSetUp = true
        }
    }
    func receiveData(data: [[[Double]]])
    {
        // receive and export that data
        
        if (canConnect())
        {
            /*communication.sendMessageData(data: data, replyHandler: nil, errorHandler: nil){
            success, error in fatalError("rEeEeEeEeEeEeEe")
             }*/
            // for some reason this gives an error ^
        }
        else
        {
            dataThatDidNotSend.append(data) // temporarily saves data that couldn't send
            // probably alert the user
        }
    }
    func receiveData(data: HKQuantity) // this is deprecated. Was meant for heart rate
    {
        // receive and export that data
        
        if canConnect()
        {
            /*communication.sendMessageData(data: data, replyHandler: nil) {
                success, error in fatalError("rEeEeEeEeEeEeEe")
                }*/
            // does not work either ;(
        }
        else
        {
            heartRateThatDidNotSend.append(data) // temporarily saves data that couldn't send
            // probably alert the user
        }
    }
    func canConnect() -> Bool
    {
        if canReachOtherDevice == true && WCSession.isSupported()
        {
            return true
        }
        else
        {
            return false
        }
    }
    func sessionReachabilityDidChange(_ session: WCSession)
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
    private func session(_ session: WCSession, didReceiveMessage message: [[[Double]]]) {
        // SAVE THE MESSAGE
        UserDefaults.standard.set(message, forKey: Date().description)
    }
}
