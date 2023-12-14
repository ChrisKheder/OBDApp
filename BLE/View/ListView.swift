//
//  ListView.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-10-16.
//

import SwiftUI

struct ListView: View{
    @EnvironmentObject var bleManager: CoreBluetoothViewModel

    var body: some View {
        ZStack{
            bleManager.navigationToDetailView(isDetailViewLinkActive: $bleManager.isConnected)
            
            GeometryReader { proxy in
                VStack{
                    if !bleManager.isSearching{
                        Button(action: {
                            if bleManager.isSearching{
                                bleManager.stopScan()
                            } else{
                                bleManager.startScan()
                            }
                        }){
                            bleManager.UIButtonView(proxy: proxy,
                                                    text: bleManager.isSearching ? "Stop Scan" : "Start Scan" )
                        }
                        
                        Text(bleManager.isBLEPower ? "" : "Bluetooth seetings are OFF")
                            .padding(10)
                        
                        Text(bleManager.foundPeripherals.isEmpty ? "" : "Choose device to connect.")
                            .foregroundColor(Color("TextColor"))
                        
                        List{
                            PeripheralCells(mqtt: bleManager.mqtt)
                        }
                        
                        
                    } else {
                        //first stack
                        Color.gray.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                        ZStack{
                            VStack{
                                ProgressView()
                            }
                            VStack{
                                Spacer()
                                Button(action: {
                                    bleManager.stopScan()
                                }){
                                    Text("Stop Scanning")
                                        .padding()
                                }
                            }
                        }
                        
                        .frame(width: proxy.size.width / 2,
                               height:proxy.size.width / 2,
                               alignment: .center)
                        .background(Color.gray.opacity(0.5))
                    }
                }
            }
        }
        
        .navigationBarTitle("SwiftUI-BLE")
    }
    
    struct PeripheralCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        var mqtt: IoTManager
        
        var body: some View{
            ForEach(0..<bleManager.foundPeripherals.count, id: \.self){ num in
                if !(bleManager.foundPeripherals[num].name == "NoName"){
                Button(action: {
                    bleManager.connectPeripheral(bleManager.foundPeripherals[num])
                    mqtt.connectToIoTDevice()
                    mqtt.startSending()
                }){
                    HStack{
                        
                        Text("\(bleManager.foundPeripherals[num].name)")
                        Spacer()
                        Text("\(bleManager.foundPeripherals[num].rssi) dBm")
                    }
                }
                }
            }
        }
    }
}
