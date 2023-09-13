//
//  LocationManager.swift
//  Diary
//
//  Created by 조호준 on 2023/09/13.
//

import CoreLocation

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var isAuthorized = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func requestLocation() {
        guard isAuthorized else {
            print("설정에서 위치 정보를 허용 해주세요")
            return
        }
        
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
        case .restricted, .denied:
            isAuthorized = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("default")
        }
    }
}
