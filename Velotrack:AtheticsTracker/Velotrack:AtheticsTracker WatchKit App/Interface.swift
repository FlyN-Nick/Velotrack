//
//  Interface.swift
//  Velotrack:AtheticsTracker WatchKit App
//
//  Created by Nicholas Assaderaghi on 3/31/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

import Foundation
import UIKit
import WatchConnectivity
import WatchKit

class Interface: UIViewController, WCSessionDelegate
{
    var dataTracker = AtheticsTracker()
    func sessionDidBecomeInactive(_ session: WCSession) {
        // oof
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // oof
    }
    
    @IBOutlet weak var DataTable: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func reportData(data: [[Double]])
    {
        
    }
}

