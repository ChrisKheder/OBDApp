//
//  Peripheral.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-10-16.
//

import CoreBluetooth

class Peripheral: Identifiable{
    var id: UUID
    var peripheral: CBPeripheralProtocol
    var name: String
    var advertisementData: [String : Any]
    var rssi: Int
    var discoverCount: Int
    
    init(_peripheral: CBPeripheralProtocol,
         _name: String,
         _advData: [String : Any],
         _rssi: NSNumber,
         _discoverCount: Int){
        id = UUID()
        peripheral = _peripheral
        name = _name
        advertisementData = _advData
        rssi = _rssi.intValue
        discoverCount = _discoverCount + 1
    }
}

