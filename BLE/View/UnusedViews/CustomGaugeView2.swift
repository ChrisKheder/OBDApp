//
//  CustomGaugeView2.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-11-17.
//

import SwiftUI

struct CustomGaugeView2: View {
    
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
                    CharacteristicCells()
                }
                .navigationBarTitle("Connection result")
                .navigationBarBackButtonHidden(true)

            }
        }
    }
    
    
    struct CharacteristicCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        
        var body: some View {
            ForEach(0..<bleManager.foundServices.count, id: \.self) { num in
                Section(header: Text("\(bleManager.foundServices[num].uuid.uuidString)")) {
                    CharacteristicCellView(service: bleManager.foundServices[num] )
                }
            }
        }
    }
    
    struct CharacteristicCellView: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        @State private var characteristicList : [String] = [""]
        @State private var characteristicValue : String = ""
        let service : Service
        
        var body: some View {
            
            EmptyView()
                .onAppear{
                    updateCharacteristicList()
                    updateValue()
                    print(characteristicValue)
                }
            ForEach(0..<characteristicList.count, id: \.self) { index in
               // CharacteristicButton(characteristic: hm10List[characteristicList[index]] ?? "noUUID", Rvalue : characteristicValue)
            }
        }
        
        
    
    struct CharacteristicButton: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        let characteristic: String
        let Rvalue: String
        
        var body: some View {
            Button(action: {
                //print("\(characteristicString(CharString: characteristic.readValue))")
                print("\(characteristic)")
            }) {
                LazyVStack{
                    HStack{
                        Text("\(characteristicName[characteristic] ?? "NoName")")
                            .font(.system(size: 14))
                            .padding(.bottom, 2)
                            .foregroundColor(Color("TextColor"))
                            .opacity(1)
                        Spacer()
                        
                        Gauge(value: Double(Rvalue) ?? 0, in: Double(minValue[characteristic] ?? 0)...(maxValue[characteristic] ?? 100)){
                            Text("\(characteristicUnit[characteristic] ?? "NoUnit")")
                        }currentValueLabel:{
                            Text("\(Rvalue)")
                        }minimumValueLabel: {
                            Text("\(Int(minValue[characteristic] ?? 0) )")
                        }maximumValueLabel: {
                            Text("\(Int(maxValue[characteristic] ?? 100) )")
                        }
                        .gaugeStyle(CustomGaugeStyle())
                        .scaleEffect(CGSize(width : 1, height : 1), anchor: .center)
                        //Spacer()            }
                    }
                }
            }
        }
    }
        
        private func updateCharacteristicList() {
            let characteristic = bleManager.foundCharacteristics[1]
            let newValue = characteristicString(CharString: characteristic.readValue)[1]
            
            if !characteristicList.contains(newValue) {
                characteristicList.append(newValue)
                print(characteristicList)
            }
        }
        private func updateValue(){
            let characteristic = bleManager.foundCharacteristics[1]
            let updatedValue = characteristicString(CharString: characteristic.readValue)[2]
            
            characteristicValue = updatedValue
            
            }
            
            
            //--------------Function to divide CharValue into ["name","value"]-----------------------//
            func characteristicString(CharString : String) -> [String] {
                
                // Define a regular expression pattern to capture key-value pairs
                    let pattern = "(\\w+)=([\\w\\d]+)"
                    
                    do {
                        let regex = try NSRegularExpression(pattern: pattern, options: [])
                        let range = NSRange(location: 0, length: CharString.utf16.count)
                        
                        // Find matches in the input string
                        let matches = regex.matches(in: CharString, options: [], range: range)
                        
                        // Extract key and value from matches
                        if let match = matches.first, matches.count == 1 {
                            let keyRange = Range(match.range(at: 1), in: CharString)!
                            let valueRange = Range(match.range(at: 2), in: CharString)!
                            
                            let key = String(CharString[keyRange])
                            let value = String(CharString[valueRange])
                            
                            print([key, value])
                            return [key, value]
                            
                        }
                        
                        return []
                    } catch {
                        print("Error creating regular expression: \(error)")
                        return []
                    }
                }
        }
    }
