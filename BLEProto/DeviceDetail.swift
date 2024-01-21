//
//  DeviceDetail.swift
//  BLEProto
//
//  Created by Joseph Noonan on 1/21/24.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    
    var device: CBPeripheral

    var body: some View {
        // Add your device detail view content here
        ZStack {
            VStack(alignment: .leading) {
                Spacer()
                Text("Device Details for \(device.name ?? "Unknown Device")")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 30)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .navigationBarTitle(device.name ?? "Unknown Device")
                Text("Device Identifier: \(device.identifier)")
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .padding(.bottom)
                
                switch device.state {
                case .disconnected:
                    Text("Device State: Disconnected")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                case .connecting:
                    Text("Device is connecting")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                case .connected:
                    Text("Device is connected")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                case .disconnecting:
                    Text("Device is disconnecting")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                default:
                    Text("Device is in an unknown state")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                }
                
                if let rssiValue = bluetoothManager.rssiValue {
                    Text("RSSI2: \(rssiValue) dBm")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                } else {
                    Text("RSSI2: Not Available")
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom)
                }
                
                if device.services == nil {
                    Text("Device Services:")
                        .font(.title3)
                        .padding(.bottom)
                    Text("No services discovered")
                    Spacer()
                    Spacer()
                    Spacer()
                    
                } else {
                    Text("Device Services:")
                        .font(.title3)
                    List(device.services!, id: \.uuid) { service in
                        Text("Service: \(service.uuid)")
                            .padding(.bottom)
                    }
                }
                
            }
            .background(.white)
        }
        .background(.white)
    }
}
