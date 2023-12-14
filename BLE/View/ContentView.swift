//
//  ContentView.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-10-16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            ListView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
