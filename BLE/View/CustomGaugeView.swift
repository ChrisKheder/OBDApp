//
//  CustomGaugeView.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-11-08.
//

import SwiftUI

struct CustomGaugeView: View {
    
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    
    
    var body: some View {
        
        
        GeometryReader { proxy in
            VStack{
                Button(action: {
                    bleManager.disconnectPeripheral()
                    bleManager.stopScan()
                }){
                    bleManager.UIButtonView(proxy: proxy, text: "Disconnect")
                }
                
                Text(bleManager.isBLEPower ? "" : "Bluetooth settings are OFF")
//                    .padding(10)
                
                List{
                    CharacteristicCells()
                }
                MapView()
                
                .navigationBarTitle("OBD2")
                .navigationBarBackButtonHidden(true)

            }
        }
    }
    
    
    struct CharacteristicCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View {
            ForEach(0..<bleManager.foundServices.count, id: \.self) { num in
                Section(header: Text("Live values")) {
                    CharacteristicCellView(service: bleManager.foundServices[num] )
                }
            }
        }
    }
    
    struct CharacteristicCellView: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        let service : Service
        
        var body: some View {
            ForEach(0..<bleManager.foundCharacteristics.count, id: \.self) { j in
                if service.uuid == bleManager.foundCharacteristics[j].service.uuid {
                    CharacteristicButton(characteristic: bleManager.foundCharacteristics[j])
                }
            }
        }
    }
    
    struct CharacteristicButton: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        let characteristic: Characteristic
        
        
        var body: some View {
                LazyVStack{
                    HStack{
                        Text("\(characteristicName[characteristic.uuid.uuidString] ?? "NoName")")
                            .font(.system(size: 14))
                            .padding(.bottom, 2)
                            .foregroundColor(Color("TextColor"))
                            .opacity(1)
                        Spacer()
                        
                        Gauge(value: Double(characteristic.readValue) ?? 0, in: Double(minValue[characteristic.uuid.uuidString] ?? 0)...(maxValue[characteristic.uuid.uuidString] ?? 100)){
                            Text("\(characteristicUnit[characteristic.uuid.uuidString] ?? "NoUnit")")
                        }currentValueLabel:{
                            Text("\(characteristic.readValue)")
                        }minimumValueLabel: {
                            Text("\(Int(minValue[characteristic.uuid.uuidString] ?? 0) )")
                        }maximumValueLabel: {
                            Text("\(Int(maxValue[characteristic.uuid.uuidString] ?? 100) )")
                        }
                        .gaugeStyle(CustomGaugeStyle())
                        .scaleEffect(CGSize(width : 1, height : 1), anchor: .center)
                        //Spacer()            }
                    }
                }
            }
        }
    }
