//
//  CoreBluetoothViewModel.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-10-16.
//

import SwiftUI
import CoreBluetooth
import Foundation

class CoreBluetoothViewModel: NSObject, ObservableObject, CBPeripheralProtocolDelegate, CBCentralManagerProtocolDelegate{
    
    @Published var isBLEPower: Bool = false
    @Published var isSearching: Bool = false
    @Published var isConnected: Bool = false
    
    @Published var foundPeripherals: [Peripheral] = []
    @Published var foundServices: [Service] = []
    @Published var foundCharacteristics: [Characteristic] = []
    
    private var centralManager: CBCentralManagerProtocol!
    private var connectedPeripheral: Peripheral!
    
    
    //--------Buffer variables--------//
    private var messageQueue: String = ""
    private var timer: Timer?
    //-------------------------------//
    
    private let serviceUUID: CBUUID = CBUUID()
    
    var mqtt: IoTManager = IoTManager()
    
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
        centralManager.connect(connectPeripheral.peripheral, options: nil)
        print("# Connected")
    }
    
    func disconnectPeripheral(){
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral.peripheral)
    }
    
    //
    func didUpdateState(_ central: CBCentralManagerProtocol){
        if central.state == .poweredOn{
            isBLEPower = true
        } else{
            isBLEPower = false
        }
    }
    
    func didDiscover(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, advertisementData: [String : Any], rssi: NSNumber){
        if rssi.intValue >= 0 { return }
        
        let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? nil
        var _name = "NoName"
        
        if peripheralName != nil {
            _name = String(peripheralName!)
        } else if peripheral.name != nil{
            _name = String(peripheral.name!)
        }
        
        let foundPeripheral: Peripheral = Peripheral(_peripheral: peripheral,
                                                     _name: _name,
                                                     _advData: advertisementData,
                                                     _rssi: rssi,
                                                     _discoverCount: 0)
        
        if let index = foundPeripherals.firstIndex(where: {$0.peripheral.identifier.uuidString == peripheral.identifier.uuidString}){
            if (foundPeripherals[index].discoverCount % 50 == 0) && !(foundPeripherals[index].name == "NoName") {
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
        connectedPeripheral.peripheral.delegate = self
        connectedPeripheral.peripheral.discoverServices(nil)
    }
    
    func didFailToConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?){
        disconnectPeripheral()
    }
    
    func didDisconnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?){
        print("disconnect")
        resetConfigure()
    }
    
    func connectionEventDidOccur(_ central: CBCentralManagerProtocol, event: CBConnectionEvent, peripheral: CBPeripheralProtocol){
        print("Connected")
    }
    
    func WillRestoreState(_ central: CBCentralManagerProtocol, dict: [String : Any]){
        
    }
    
    func didUpdateANCSAuthorization(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol){
        
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
            let setCharacteristic: Characteristic = Characteristic(_characteristic: characteristic,
                                                                   _description: "",
                                                                   _uuid: characteristic.uuid,
                                                                   _readValue: "",
                                                                   _service: characteristic.service!)
            
            foundCharacteristics.append(setCharacteristic)
            
            //setNotifyValue allows notifcation of update value which lets us update the displayed value.
            peripheral.setNotifyValue(true, for: characteristic)
            peripheral.readValue(for: characteristic)
            
            
            
            
        }
    }
    
    func didUpdateValue(_ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic, error: Error?){
        guard let characteristicValue = characteristic.value else { return }
        
        
        
        //---------------------------------------- code for multiple characteristics------------------------------//
        if let index = foundCharacteristics.firstIndex(where: {$0.uuid.uuidString == characteristic.uuid.uuidString}){
            
            //------------------------Convert hex bit into decimal string------------------------//
            foundCharacteristics[index].readValue = characteristicValue.map({String(format:"%d", $0)}).joined()

            //check if we already have a stored value for the characteristic in the buffer, if not store it in the buffer
            if !(mqtt.containing(field: fields[characteristic.uuid.uuidString] ?? "field8=")){
                mqtt.addMessage(fields[characteristic.uuid.uuidString] ?? "field8=" + foundCharacteristics[index].readValue)
            }
            
           
            
        }
    }
        
        func didWriteValue(_ peripheral: CBPeripheralProtocol, descriptor: CBDescriptor, error: Error?){
            
        }
        
    }


//-------------------------Different working codes for didUpdateValue that fulfill different functions-----------------------------//


//---------------------------------------Working code for sending one field at a time---------------------------------------//
//            if foundCharacteristics[index].readValue != ""{
//                //            Publish data to sevrer as soon as the characteristic updates.
//                mqtt.publishData(topic: "channels/2351521/publish", message: "\(fields[characteristic.uuid.uuidString] ?? "field8=")" + "\(foundCharacteristics[index].readValue)")
//
//
//            }else{
//                print("\(foundCharacteristics[index].readValue)")
//            }
   
   //----------------------------------------One Characteristic that send hex-encoded string------------------------------//
   
   //        if let index = foundCharacteristics.firstIndex(where: { $0.uuid.uuidString == characteristic.uuid.uuidString }) {
   //                // Convert hexadecimal string to data
   //                if let data = data(fromHexString: characteristicValue) {
   //                    // Convert data to string
   //                    if let stringValue = String(data: data, encoding: .utf8) {
   //                        foundCharacteristics[index].readValue = stringValue
   //                        //print("Characteristic Value: \(stringValue)")
   //                    } else {
   //                        print("Failed to convert data to UTF-8 string.")
   //                    }
   //                } else {
   //                    print("Failed to convert hexadecimal string to data.")
   //                }
   //            }
   //        }
   //
   //        // Helper function to convert a hexadecimal string to data
   //        func data(fromHexString hexString: Data) -> Data? {
   //            var hex = hexString.map { String(format: "%02x", $0) }.joined()
   //            var data = Data()
   //
   //            while hex.count > 0 {
   //                let index = hex.index(hex.startIndex, offsetBy: 2)
   //                let byte = String(hex[..<index])
   //                hex = String(hex[index...])
   //
   //                if var num = UInt8(byte, radix: 16) {
   //                    data.append(&num, count: 1)
   //                } else {
   //                    print("Invalid hexadecimal character detected: \(byte)")
   //                    return nil
   //                }
   //            }
   //            return data

