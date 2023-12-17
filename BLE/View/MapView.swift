//
//  MapView.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-12-17.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var manager = LocationManager()
    
    var body: some View {
        
        Map(coordinateRegion: $manager.region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow))
        .frame(maxWidth: .infinity, maxHeight: 300)
        }
}


