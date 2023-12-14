//
//  BLEApp.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-10-16.
//

import SwiftUI

@main
struct BLEApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CoreBluetoothViewModel())
        }
    }
}
