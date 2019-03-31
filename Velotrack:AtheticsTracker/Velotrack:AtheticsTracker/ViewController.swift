//
//  ViewController.swift
//  Velotrack:AtheticsTracker
//
//  Created by Nicholas Assaderaghi on 3/30/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

import UIKit
import WatchConnectivity
import WatchKit

class ViewController: UIViewController, WCSessionDelegate
{
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
}

