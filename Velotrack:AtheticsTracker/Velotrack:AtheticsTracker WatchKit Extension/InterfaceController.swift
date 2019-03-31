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
import CoreMotion
import HealthKit

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    
    @IBOutlet var Start: WKInterfaceButton!
    @IBOutlet var AccelerationLabel: WKInterfaceLabel!
    @IBOutlet var RotationLabel: WKInterfaceLabel!
    
    
    var hasStarted = false
    let motionManager = CMMotionManager()
    //let healthManager = HKHealthStore()
    let wristLocationIsLeft = WKInterfaceDevice.current().wristLocation == .left
    var updateInterval: Double = 1
    var timerBoolean = false
    var theSyncyroziner = Synchronizer()
    var motionDataSession: [[[Double]]] = Array()
    
    func StartTracking()
    {
        print("StartTracking method has been triggered")
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
                    print("Timer has been invalidated")
                }
                print("Timer!!")
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
                print("\(motionData)")
                self.receiveNewData(data: motionData)
                self.motionDataSession.append(motionData)
                //self.theSyncyroziner.receiveData(data: motionData)
                /*var accurateData = CMDeviceMotion()
                 accurateData.rotationRate
                 accurateData.userAcceleration*/
            }
        }
        else
        {
            print("Data required not available")
        }
    }
    func StopTracking()
    {
        print("Tracking has been stopped")
        timerBoolean = false
        motionManager.stopGyroUpdates()
        motionManager.stopAccelerometerUpdates()
        self.theSyncyroziner.receiveData(data: motionDataSession)
        motionDataSession.removeAll()
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
    
    @IBAction func start(button: WKInterfaceButton)
    {
        print("button triggered")
        if !hasStarted
        {
            StartTracking()
            print("session beggining")
        }
        else
        {
            StopTracking()
            print("session ending")
        }
    }
    func receiveNewData(data: [[Double]])
    {
        print("data should have been received")
        //let acelX: String = "x, \(data[1][0])"
        let acelX: String = "x, hi"
        let acelY: String = "y, \(data[1][1])"
        let acelZ: String = "z, \(data[1][2])"
        AccelerationLabel.setText("Acceleration: " + acelX + acelY + acelZ)
        let rotX: String = "x, \(data[0][0])"
        let rotY: String = "y, \(data[0][1])"
        let rotZ: String = "z, \(data[0][2])"
        RotationLabel.setText("Rotation: " + rotX + rotY + rotZ)

    }
}
