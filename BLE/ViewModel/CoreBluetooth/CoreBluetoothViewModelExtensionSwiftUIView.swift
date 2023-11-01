//
//  CoreBluetoothViewModelExtensionSwiftUIView.swift
//  BLE
//
//  Created by Simon Khederchah on 2023-10-16.
//

import SwiftUI
import CoreBluetooth

extension CoreBluetoothViewModel{
    func navigationToDetailView(isDetailViewLinkActive: Binding<Bool>) -> some View{
        let navigationToDetailView =
            NavigationLink("",
                                   destination: DetailView(),
                                   isActive: isDetailViewLinkActive).frame(width: 0, height: 0)
            return navigationToDetailView
    }
}

extension CoreBluetoothViewModel{
    func UIButtonView(proxy: GeometryProxy, text: String) -> some View{
        let UIButtonView =
        VStack{
            Text(text)
                .frame(width: proxy.size.width/1.1,
                       height: 50,
                       alignment: .center)
                .foregroundColor(Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2))
        }
        return UIButtonView
    }
}
