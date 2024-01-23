//
//  ContentView.swift
//  BLEProto
//
//  Created by Joseph Noonan on 1/21/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
   

    var body: some View {
        NavigationView {
            List(bluetoothManager.peripheralDevices, id: \.self) { device in
                if device.name != nil {
                    NavigationLink(destination: DeviceDetailView(device: device)) {
                    
                        Text(device.name ?? "Unknown Device")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if device.state == .connected {
                            Image(systemName: "star.fill")
                                .font(.title)
                                .frame(width: 150, alignment: .center)
                        } else {
                            Image(systemName: "star")
                                .font(.title)
                                .frame(width: 150, alignment: .center)
                        }
                    }
                }
            }
            .navigationBarTitle("Bluetooth Devices")
        }
        .padding(.leading, 10)
        .onAppear {
            // The central manager is already initialized in BluetoothManager
        }
    }
}

#Preview {
    ContentView()
}
