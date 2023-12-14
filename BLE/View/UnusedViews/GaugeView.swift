//
//  SwiftUIView.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-11-01.
//

import SwiftUI

struct GaugeView: View {
    
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
                    .padding(10)
                
                List{
                    CharacteriticCells()
                }
                .navigationBarTitle("Connection result")
                .navigationBarBackButtonHidden(true)
            }
        }
    }
        
        
    struct CharacteriticCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View{
            ForEach(0..<bleManager.foundServices.count, id: \.self){ num in
                Section(header: Text("\(bleManager.foundServices[num].uuid.uuidString)")){
                    ForEach(0..<bleManager.foundCharacteristics.count, id: \.self){ j in
                        if bleManager.foundServices[num].uuid == bleManager.foundCharacteristics[j].service.uuid{
                            Button(action:{
                                //write action
                            }){
                                VStack{
                                    HStack{
                                        
                                        Text("\(characteristicName[bleManager.foundCharacteristics[j].uuid.uuidString] ?? "NoName") [\(characteristicUnit[bleManager.foundCharacteristics[j].uuid.uuidString] ?? "NoUnit")]")
                                            .font(.system(size: 14))
                                            .padding(.bottom, 2)
                                        Spacer()
                                        
                                        Spacer()
                                        Gauge(value: Double(bleManager.foundCharacteristics[j].readValue) ?? 0.0, in: 0.0...100.0){
                                        }currentValueLabel:{
                                            Text("\(bleManager.foundCharacteristics[j].readValue)")
                                                .foregroundColor(Color.blue)
                                        }minimumValueLabel: {
                                            Text("\(minValue[bleManager.foundCharacteristics[j].uuid.uuidString] ?? 0)")
                                        }maximumValueLabel: {
                                            Text("\(maxValue[bleManager.foundCharacteristics[j].uuid.uuidString] ?? 100)")
                                        }
                                        
                                        .gaugeStyle(.accessoryCircular)
                                        .tint(Gradient(colors: [.green, .yellow, .orange, .red]))
                                        .scaleEffect(CGSize(width : 1.25, height : 1.25), anchor: .center)
                                        .frame(alignment: .center)
                                        //Spacer()
                                        
//                                        Text("\(characteristicUnit[bleManager.foundCharacteristics[j].uuid.uuidString] ?? "NoUnit")")
//                                            .font(.system(size: 14))
//                                            .padding(.bottom, 2)
//                                        Spacer()
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
        
