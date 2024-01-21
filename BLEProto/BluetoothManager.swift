//
//  BluetoothManager.swift
//  BLEProto
//
//  Created by Joseph Noonan on 1/20/24.
//

import Foundation
import SwiftUI
import CoreBluetooth

class MyPeripheralDelegate: NSObject, ObservableObject, CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("peripheral didDiscoverServices reached")
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }

        if let services = peripheral.services {
            for service in services {
                print("Discovered service: \(service.uuid)")
            }
        }
    }
}

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var rssiValue: NSNumber?
    @Published var peripheralDevices: [CBPeripheral] = []
    private var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var peripheralDelegate: MyPeripheralDelegate!

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        peripheralDelegate = MyPeripheralDelegate()
        print("centralManager super.init reached")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("RSSI Value Start: \(RSSI)")
        if let error = error {
            print("Error reading RSSI: \(error.localizedDescription)")
            rssiValue = 0
        } else {
            print("RSSI1: \(RSSI) dBm")
            rssiValue = RSSI
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        print("centalManagerDidUpdateState reached")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if !peripheralDevices.contains(peripheral) {
            peripheralDevices.append(peripheral)
        }
        print("Central Manager didDiscover reached")
        if peripheral.state == .disconnected {
            centralManager.connect(peripheral, options: nil)
            print("Peripheral State: \(peripheral.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Peripheral connected, now read RSSI
        print("Central Manager didConnect reached")
        peripheral.delegate = peripheralDelegate
        peripheral.readRSSI()
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected: \(peripheral)")
        // Handle disconnection, update UI, etc.
        peripheralDevices.removeAll { $0 == peripheral }
    }
}




