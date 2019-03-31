//
//  InterfaceController.swift
//  Velotrack:AtheticsTracker WatchKit Extension
//
//  Created by Nicholas Assaderaghi on 3/30/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    
    @IBOutlet var Start: WKInterfaceButton!
    var theAthleticMetrics = AthleticMetrics();
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        super.willActivate()
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
