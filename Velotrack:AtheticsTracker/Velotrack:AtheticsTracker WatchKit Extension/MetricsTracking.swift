//
//  MetricsTracking.swift
//  Velotrack:AtheticsTracker WatchKit Extension
//
//  Created by Nicholas Assaderaghi and Owen Hsu on 3/30/19 and 3/31/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

import Foundation
import CoreMotion
import WatchKit

/**
 `MotionManagerDelegate` exists to inform delegates of motion changes.
 These contexts can be used to enable application specific behavior.
 */
/*protocol MotionManagerDelegate: class {
    func didUpdateForehandSwingCount(_ manager: MetricsTracking, forehandCount: Int)
    func didUpdateBackhandSwingCount(_ manager: MetricsTracking, backhandCount: Int)
}*/
class MetricsTracking: NSObject
{
    // MARK: Properties
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    
    // MARK: Application Specific Constants
    
    // These constants were derived from data and should be further tuned for your needs.
    let yawThreshold = 1.95 // Radians
    let rateThreshold = 5.5    // Radians/sec
    let resetThreshold = 5.5 * 0.05 // To avoid double counting on the return swing.
    
    // The app is using 50hz data and the buffer is going to hold 1s worth of data.
    let sampleInterval = 1.0 / 50
    let rateAlongGravityBuffer = RunningBuffer(size: 50)
    
    //weak var delegate: MotionManagerDelegate?
    
    var recentDetection = false
    
    // MARK: Initialization
    
    override init() {
        // Serial queue for sample handling and calculations.
        queue.maxConcurrentOperationCount = 1
        queue.name = "MotionManagerQueue"
    }
    
    // MARK: Motion Manager
    
    func startUpdates() {
        if !motionManager.isDeviceMotionAvailable {
            print("Device Motion is not available.")
            return
        }
        
        // Reset everything when we start.
        resetAllState()
        
        motionManager.deviceMotionUpdateInterval = sampleInterval
        motionManager.startDeviceMotionUpdates(to: queue) { (deviceMotion: CMDeviceMotion?, error: Error?) in
            if error != nil {
                print("Encountered error: \(error!)")
            }
            
            if deviceMotion != nil {
                self.processDeviceMotion(deviceMotion!)
            }
        }
    }
    
    func stopUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    // MARK: Motion Processing
    
    func processDeviceMotion(_ deviceMotion: CMDeviceMotion) {
        let gravity = deviceMotion.gravity
        let rotationRate = deviceMotion.rotationRate
        
        let rateAlongGravity = rotationRate.x * gravity.x
            + rotationRate.y * gravity.y
            + rotationRate.z * gravity.z
        rateAlongGravityBuffer.addSample(rateAlongGravity)
        
        if !rateAlongGravityBuffer.isFull() {
            return
        }
        
        
        // Reset after letting the rate settle to catch the return swing.
        if (recentDetection && abs(rateAlongGravityBuffer.recentMean()) < resetThreshold) {
            recentDetection = false
            rateAlongGravityBuffer.reset()
        }
    }
    
    // MARK: Data and Delegate Management
    
    func resetAllState() {
        rateAlongGravityBuffer.reset()
        recentDetection = false
    
    }
}


