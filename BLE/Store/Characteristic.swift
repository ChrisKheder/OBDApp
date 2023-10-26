//
//  Characteristic.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-10-16.
//

import CoreBluetooth

class Characteristic: Identifiable{
    var id: UUID
    var characteristic: CBCharacteristic
    var description: String
    var uuid: CBUUID
    var readValue: String
    var service: CBService
    
    init(_characteristic: CBCharacteristic,
         _description: String,
         _uuid: CBUUID,
         _readValue: String,
         _service: CBService){
        
        id = UUID()
        characteristic = _characteristic
        description = _description == "" ? "NoData" : _readValue
        uuid = _uuid
        readValue = _readValue == "" ? "NoName" : _description
        service = _service
    }
}
