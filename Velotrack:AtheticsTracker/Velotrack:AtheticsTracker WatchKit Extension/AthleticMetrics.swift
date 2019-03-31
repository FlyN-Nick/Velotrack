//
//  AthleticMetrics.swift
//  Velotrack:AtheticsTracker WatchKit Extension
//
//  Created by Nicholas Assaderaghi and Owen Hsu on 3/30/19 & 3/31/19.
//  Copyright © 2019 Velotrack Inc. All rights reserved.
//

//import Foundation
import WatchKit
import CoreMotion

class AthleticMetrics: NSObject
{
    let motionManager = CMMotionManager()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    var updateInterval = 1.0/60.0
    var timerBoolean = false
    func StartTracking()
    {
        if motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable
        {
            motionManager.accelerometerUpdateInterval = updateInterval
            motionManager.gyroUpdateInterval = updateInterval
            motionManager.startGyroUpdates()
            motionManager.startAccelerometerUpdates()
            timerBoolean = true
            Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
                if !self.timerBoolean
                {
                    timer.invalidate()
                }
                var gyroArray: Array<Double> = Array()
                var accelArray: Array<Double> = Array()
                if let gyroData = self.motionManager.gyroData
                {
                    let gyro_x = gyroData.rotationRate.x
                    let gyro_y = gyroData.rotationRate.y
                    let gyro_z = gyroData.rotationRate.z
                    gyroArray = [(gyro_x), (gyro_y), (gyro_z)]
                }
                if let accelData = self.motionManager.accelerometerData
                {
                    let accel_x = accelData.acceleration.x
                    let accel_y = accelData.acceleration.y
                    let accel_z = accelData.acceleration.z
                    accelArray = [(accel_x), (accel_y), (accel_z)]
                }
                var motionData = [gyroArray, accelArray]
                // push the motionData array to the class that communicates with the iphone
            }
        }
    }
    func StopTracking()
    {
        timerBoolean = false
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
    }
}
