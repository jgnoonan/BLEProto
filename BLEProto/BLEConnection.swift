//
//  BLEConnection.swift
//  BLEProto
//
//  Created by Joseph Noonan on 1/18/24.
//

import Foundation
import UIKit
import CoreBluetooth

open class BLEConnection: NSObject, ObservableObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    // Properties
    private var centralManager: CBCentralManager! = nil
    private var peripheral: CBPeripheral!

    public static let bleServiceUUID = CBUUID.init(string: "74DCD514-CACF-49BC-ACF7-396BD0CF58C1")
    public static let bleCharacteristicUUID = CBUUID.init(string: "EBA93FC8-639E-4FF9-98FA-DE4F841DC317")

    // Array to contain names of BLE devices to connect to.
    // Accessable by ContentView for Rendering the SwiftUI Body on change in this array.
    @Published var scannedBLEDevices: [String] = []

    func startCentralManager() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Central Manager State: \(self.centralManager.state)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           self.centralManagerDidUpdateState(self.centralManager)
        }
    }

    // Handles BT Turning On/Off
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Before Switch Statement State: \(central.state)")
        switch (central.state) {
           case .unsupported:
            print("BLE is Unsupported")
            break
           case .unauthorized:
            print("BLE is Unauthorized")
            break
           case .unknown:
            print("BLE is Unknown")
            break
           case .resetting:
            print("BLE is Resetting")
            break
           case .poweredOff:
            print("BLE is Powered Off")
            break
           case .poweredOn:
            print("BLE is Powered On")
            print("Central scanning for", BLEConnection.bleServiceUUID);
            self.centralManager.scanForPeripherals(withServices: [BLEConnection.bleServiceUUID],options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
//            self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
//            break
        default:
            print("Should Never Get Here")
        }

       if(central.state != CBManagerState.poweredOn)
       {
           // In a real app, you'd deal with all the states correctly
           return;
       }
    }


    // Handles the result of the scan
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Peripheral Name: \(String(describing: peripheral.name))  RSSI: \(String(RSSI.doubleValue))")
        let peripheralUUID = peripheral.identifier
        print("Peripheral UUID: \(peripheralUUID)")
        // We've found it so stop scan
        self.centralManager.stopScan()
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.scannedBLEDevices.append(peripheral.name!)
        self.peripheral.delegate = self
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
    }


    // The handler if we do connect successfully
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your BLE Board")
            peripheral.discoverServices([BLEConnection.bleServiceUUID])
        }
    }


    // Handles discovery event
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Peripheral Identifier: \(peripheral.identifier)")
        if let services = peripheral.services {
            for service in services {
                if service.uuid == BLEConnection.bleServiceUUID {
                    print("BLE Service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([BLEConnection.bleCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }

    // Handling discovery of characteristics
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Count of Service Characteristics: \(String(describing: service.characteristics?.count))")
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("characteristic id: \(characteristic.uuid)")
                if characteristic.uuid == BLEConnection.bleServiceUUID {
                    print("BLE service characteristic found")
                } else {
                    print("Characteristic not found.")
                }
            }
        }
    }
}
