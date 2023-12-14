//
//  CustomGaugeStyle.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-11-07.
//

import Foundation
import SwiftUI

struct CustomGaugeStyle: GaugeStyle {
    
    private var purpleGradient = LinearGradient(gradient: Gradient(colors: [.green, .yellow, .orange, .red]), startPoint: .trailing, endPoint: .leading)
    
    
    func makeBody(configuration: Configuration) -> some View {
        let endAngle = Angle(degrees: 135 + (configuration.value * 270))
        let radius: CGFloat = 35
        
            ZStack {
                
                Circle()
                    .foregroundColor(Color(.systemGray6))
                    .opacity(1)

                
                Circle()
                //Gradient trim
                    .trim(from: 0, to: 0.782)
                    .stroke(purpleGradient, lineWidth: 7)
                    .opacity(1)
                    .rotationEffect(.degrees(128.5))
                
                //Min and max value lable display and placemant
                    .overlay(alignment: .bottomLeading) {
                        configuration.minimumValueLabel
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundColor(.green)
                            .opacity(1)
                            .offset(x:15,y: 0)
                    }
                
                    .overlay(alignment: .bottomTrailing) {
                        configuration.maximumValueLabel
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundColor(.red)
                            .opacity(1)
                            .offset(x:-14,y: 0)
                    }
                
                //Marker of value both white part and rainbow part
                Circle()
                    .frame(width: 0.9, height: 0.9)
                    .foregroundColor(Color.clear)
                    .opacity(0)
                    .offset(x: radius * cos(endAngle.radians), y: radius * sin(endAngle.radians))
                
                Circle()
                    .trim(from:0, to: 1)
                    .stroke(Color.white, lineWidth:2.5)
                    .frame(width: 8, height: 8)
                    .opacity(1)
                    .offset(x: radius * cos(endAngle.radians), y: radius * sin(endAngle.radians))
                
                

                
                    
                //Current Value display and Unit display
                VStack {
                    configuration.currentValueLabel
                        .font(.system(size: 21, weight: .bold, design: .rounded))
                        .foregroundColor(Color("TextColor"))
                        .opacity(1)
                    configuration.label
                        .font(.system(size: 10, design: .rounded))
                        .bold()
                        .foregroundColor(Color("TextColor"))
                        .opacity(1)
                    
                }
                
                

                
                .frame(width: 58, height: 58)
                
                
            }
            
            .frame(width: 70, height: 70)
            .opacity(1)
    }
        
    }
