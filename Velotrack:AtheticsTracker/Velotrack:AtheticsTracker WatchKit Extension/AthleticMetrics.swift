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
import HealthKit

class AthleticMetrics: NSObject
{    
    let motionManager = CMMotionManager()
    //let healthManager = HKHealthStore()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    var updateInterval = 1.0/60.0
    var timerBoolean = false
    var theSyncyroziner = Synchronizer()
    var motionDataSession: [[[Double]]] = Array()
    
    func StartTracking()
    {
        if motionManager.isAccelerometerAvailable && motionManager.isGyroAvailable/* && motionManager.isDeviceMotionAvailable*/
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
                var theHeartRate: HKQuantity
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
                /*if HKHealthStore.isHealthDataAvailable()
                {
                    theHeartRate = self.trackHeartRate()
                    self.theSyncyroziner.receiveData(data: theHeartRate)
                }*/
                var motionData = [[Double]]()
                motionData = [gyroArray, accelArray]
                self.motionDataSession.append(motionData)
                //self.theSyncyroziner.receiveData(data: motionData)
                /*var accurateData = CMDeviceMotion()
                 accurateData.rotationRate
                 accurateData.userAcceleration*/
            }
        }
    }
    func StopTracking()
    {
        timerBoolean = false
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
        self.theSyncyroziner.receiveData(data: motionDataSession)
    }
    /*func trackHeartRate() -> HKQuantity
    {
        var heartRate : HKQuantity
        if HKHealthStore.isHealthDataAvailable()
        {
            let healthStore = HKHealthStore()
            let readableTypes = Set([HKSampleType.quantityType(forIdentifier: .heartRate)!])
            healthStore.requestAuthorization(toShare: nil, read: readableTypes) {
                success, error in
                guard let heartRateType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
                    fatalError("*** Unable to create a heart rate type ***")
                }
                let heartRateForInterval = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 95.0)
                //let heartRateForIntervalSample = HKQuantitySample(type: heartRateType, quantity: heartRateForInterval, startDate: intervals[0], endDate: intervals[1])
                // in the examples i have found, this should have worked ^
                heartRate = heartRateForIntervalSample
                
            }
            return heartRate
        }
        else
        {
            fatalError("Unable to get heart rate data")
        }
    }*/
}
