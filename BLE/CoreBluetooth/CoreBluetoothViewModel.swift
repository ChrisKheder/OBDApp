//
//  CoreBluetoothViewModel.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-10-16.
//

import SwiftUI
import CoreBluetooth

class CoreBluetoothViewModel: NSObject, ObservableObject, CBPeripheralProtocolDelegate, CBCentralManagerProtocolDelegate{
    
    
    @Published var isBLEPower: Bool = false
    @Published var isSearching: Bool = false
    @Published var isConnected: Bool = false
    
    @Published var foundPeripherals: [Peripheral] = []
    @Published var foundServices: [Service] = []
    @Published var foundCharacteristics: [Characteristic] = []
    
    private var centralManager: CBCentralManagerProtocol!
    private var connectedPeripheral: Peripheral!
    
    private let serviceUUID: CBUUID = CBUUID()
    
    
    //Setting the initializing. #if#end is a if statement that is checked before compiling.
    //Depending on if the compiling is made for simulation or not will a mock Central manager be made because CB cannot be simulated.
    override init(){
        super.init()
        #if targetEnvironment(simulator)
        centralManager = CBCentralManagerMock(delegate: self, queue: nil)
        #else
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        #endif
    }
    
    //Reset the configurations, and empting all the list.
    private func resetConfigure(){
        withAnimation {
            isSearching = false
            isConnected = false
            
            foundPeripherals = []
            foundServices = []
            foundCharacteristics = []
        }
    }
    
    //Control func
    func startScan(){
        //Allows scan and discovery of duplicates of advertisment. Good if you want to track devices that might advertise repeatidly
        let scanOption = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        //Core Bluetooth function for scanning after peripherals, it is possible to set filter such as UUIDs
        centralManager?.scanForPeripherals(withServices: nil, options: scanOption)
        print("# Start Scan")
        isSearching = true
    }
    func stopScan(){
        
        //Using own written function to disconnect from peripheral before stopping scan
        disconnectPeripheral()
        centralManager?.stopScan()
        print("# Stop Scan")
        isSearching = false
    }
    
    func connectPeripheral(_ selectPeripheral: Peripheral?){
        guard let connectPeripheral = selectPeripheral else { return }
        connectedPeripheral = selectPeripheral
        centralManager.connect(connectPeripheral.peripheral)
    }
    
    func disconnectPeripheral(){
        guard let connectPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral as! CBPeripheralProtocol)
    }
    
    //
    func didUpdateState(_ central: CBCentralManagerProtocol){
        if central.state == .poweredOn{
            isBLEPower = true
        } else{
            isBLEPower = false
        }
    }
    
    func didDiscover(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, advertismentData: [String : Any], rssi: NSNumber){
        if rssi.intValue >= 0 { return }
        
        let peripheralName = advertismentData[CBAdvertisementDataLocalNameKey] as? String ?? nil
        var _name = "NoName"
        
        if peripheralName != nil {
            _name = String(peripheralName!)
        } else if peripheral.name != nil{
            _name = String(peripheral.name!)
        }
        
        let foundPeripheral: Peripheral = Peripheral(_peripheral: peripheral,
                                                     _name: _name,
                                                     _advData: advertismentData,
                                                     _rssi: rssi,
                                                     _discoverCount: 0)
        
        if let index = foundPeripherals.firstIndex(where: {$0.peripheral.identifier.uuidString == peripheral.identifier.uuid}){
            if foundPeripherals[index].discoverCount % 50 == 0 {
                foundPeripherals[index].name = _name
                foundPeripherals[index].rssi = rssi.intValue
                foundPeripherals[index].discoverCount += 1
            } else {
                foundPeripherals[index].discoverCount += 1
            }
        } else{
            foundPeripherals.append(foundPeripheral)
            DispatchQueue.main.async{ self.isSearching = false }
        }
    }

    func didConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol){
        guard let connectedPeripheral = connectedPeripheral else { return }
        isConnected = true
        connectedPeripheral.delegate = self
        connectedPeripheral.discoverServices([])
    }
    
    func didFailToConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?){
        disconnectPeripheral()
    }
    
    func didDisconnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?){
        print("disconnect")
        resetConfigure()
    }
    
    func connectionEventDidOccur(_ central: CBCentralManagerProtocol, event: CBConnectionEvent, peripheral: CBPeripheralProtocol){
        
    }
    
    func willRestoreState(_ central: CBCentralManagerProtocol, dict: [String : Any]){
        
    }
    
    func didUpdateANCSauthorization(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol){
        
    }
    
    
    // CoreBluetooth peripheral delegate
    func didDiscoverServices(_ peripheral: CBPeripheralProtocol, error: Error?){
        peripheral.services?.forEach { service in
            let setService = Service(_uuid: service.uuid, _service: service)
            
            foundServices.append(setService)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheralProtocol, service: CBService, error: Error?){
        service.characteristics?.forEach{ characteristic in
            let setCharacteristic: CBCharacteristic = Characteristic(_characteristic: characteristic,
                                                                     _description: "",
                                                                     _uuid: characteristic.uuid,
                                                                     _readValue: "",
                                                                     _service: characteristic.service!)
            foundCharacteristics.append(setCharacteristic)
            peripheral.readValue(for: characteristic)
            
        }
    }
    
    func didUpdateValue(_ peripheral: CBPeripheral, characteristic: CBCharacteristic, error: Error?){
        guard let characteristicValue = characteristic.value else { return }
        
        if let index = foundCharacteristics.firstIndex(where: {$0.uuid.uuidString == characteristic.uuid.uuidString}){
            
            foundCharacteristics[index].readValue = characteristicValue.map({String(format:"%02x", $0)}).joined()
        }
    }
    
    func didwriteValue(_ peripheral: CBPeripheral, descriptor: CBDescriptor, error: Error?){
        
    }
    
}


