//
//  Service.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-10-16.
//

import CoreBluetooth

class Service: Identifiable {
    var id: UUID
    var uuid: CBUUID
    var service: CBService
    
    init(_uuid: CBUUID,
         _service: CBService){
        
        id = UUID()
        uuid = _uuid
        service = _service
    }
}
