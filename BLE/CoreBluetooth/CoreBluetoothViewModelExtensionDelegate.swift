//
//  CoreBluetoothViewModelExtensionDelegate.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-10-16.
//

import CoreBluetooth

extension CoreBluetoothViewModel: CBCentralManagerDelegate, CBPeripheralDelegate{
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        didDiscoverServices(peripheral, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        didDiscoverCharacteristics(peripheral, service: service, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        didUpdateValue(peripheral, characteristic: characteristic, error: error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?){
        didwriteValue(peripheral, descriptor: descriptor, error: error)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        didUpdateState(central)
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]){
        willRestoreState(central, dict: dict)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData advertismentData: [String: Any], rssi RSSI: NSNumber){
        didDiscover(central, peripheral: peripheral, advertismentData: advertismentData, rssi: RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        didConnect(central, peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        didFailToConnect(central, peripheral: peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        didDisconnect(central, peripheral: peripheral, error: error)
    }
    
    func centralManager(_ central: CBCentralManager,
                        connectionEventDidOccur event: CBConnectionEvent,
                        for peripheral: CBPeripheral){
        connectionEventDidOccur(central, event: event, peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral){
        didUpdateANCSauthorization(central, peripheral: peripheral)
    }
}
