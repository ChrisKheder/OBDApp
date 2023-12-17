//
//  LocationManager.swift
//  BLE
//
//  Created by Christian Khederchah on 2023-12-17.
//

import Foundation
import MapKit


final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion()
    
    override init() {
            super.init()
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    self.setup()
        }
    
    
    private func setup() {
        switch locationManager.authorizationStatus{
            
            //If we are authorized then we request location just once,
            // to center the map
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            // If we dont, we request authorization
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}
    
extension LocationManager: CLLocationManagerDelegate {
    
    
    
    
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
            guard .authorizedWhenInUse == manager.authorizationStatus else {return}
            locationManager.requestLocation()
            print("Please authorize use of location")
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
            print("LocationManager failed with error: \(error)")
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            locationManager.stopUpdatingLocation()
            locations.last.map{
                region = MKCoordinateRegion(
                    center: $0.coordinate,
                    span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
            }
        }
        
    func centerMap(){
        locationManager.requestLocation()
        locationManager.stopUpdatingLocation()
    }
        
    }

