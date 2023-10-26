//
//  CBPeripheralMock.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-10-19.
//

import Foundation
import CoreBluetooth

class CBPeripheralMock: Mock, CBPeripheralProtocol {
    weak var delegate: CBPeripheralDelegate?
    var state: CBPeripheralState = .disconnected
    var identifier: UUID
    var name: String?
    var services: [CBService]?
    var manager: CBCentralManagerMock
    
    private var serviceCharacteristic = serviceCharacteristicsMock()
    
    var debugDescription: String{
        return "\(identifier) \(name ?? "")"
    }
    
    init(identifier: UUID, name: String?, manager: CBCentralManagerMock){
        self.identifier = identifier
        self.name = name
        self.manager = manager
        log(#function)
    }
    
    func didConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol){
        state = .connected
    }
    
    func didDisconnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?){
        state = .disconnected
    }
    
    func discoverServices(_ serviceUUIDs: [CBUUID]?) {
        log(#function)
        
        services = serviceCharacteristic.service()
        
        guard let delegate = delegate as? CBPeripheralProtocolDelegate else { return }
        delegate.didDiscoverServices(self, error: nil)
    }
    
    func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]?, for service: CBService) {
        log(#function)
        guard let mutableService = service as? CBMutableService,
              let delegate = delegate as? CBPeripheralProtocolDelegate
        else { return }
        
        mutableService.characteristics = serviceCharacteristic.characteristics(service.uuid)
        
        delegate.didDiscoverCharacteristics(self, service: mutableService, error: nil)
    }
    
    func readValue(for characteristic: CBCharacteristic) {
        log(#function)
        
        guard let mutableCharacteristic = characteristic as? CBMutableCharacteristic,
                let delegate = delegate as? CBPeripheralProtocolDelegate
        else { return }
        
        mutableCharacteristic.value = serviceCharacteristic.value(uuid: mutableCharacteristic.uuid)
        
        if let _ = mutableCharacteristic.value {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                delegate.didUpdateValue(self,
                                        characteristic: characteristic,
                                        error: nil)
            }
        }
    }
    
    func writeValue(_ data: Data, for characteristic: CBCharacteristic, type: CBCharacteristicWriteType){
        log(#function)
        
        guard let mutableCharacteristic = characteristic as? CBMutableCharacteristic,
              let delegate = delegate as? CBPeripheralProtocolDelegate
        else { return }
        
        serviceCharacteristic.writeValue(uuid: mutableCharacteristic.uuid, writeValue: data)
        
        mutableCharacteristic.value = serviceCharacteristic.value(uuid: mutableCharacteristic.uuid)
        
        if let _ = mutableCharacteristic.value{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                delegate.didUpdateValue(self,
                                        characteristic: characteristic,
                                        error: nil)
            }
        }
    }
    
    func setNotifyValue(_ enable: Bool, for characteristic: CBCharacteristic) {
        log(#function)
    }
    
    private func dataNotify(_ delegate: CBPeripheralProtocolDelegate){
        log(#function)
    }
    
    func discoverDescriptors(for Characteristic: CBCharacteristic){
        log(#function)
    }
}
