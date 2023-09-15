//
//  LocationManager.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/09/15.
//

import CoreLocation

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private(set) var isAuthorized = false
    
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func requestLocation() {
        guard isAuthorized else {
            print("설정해서 위치 정보를 허용해주세요: \(#function)")
            return
        }
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
        case .restricted, .denied:
            isAuthorized = false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Error: \(#function)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isAuthorized,
              let coordinate = locations.last?.coordinate else {
            
            return
        }
        
        let latitude = String(coordinate.latitude)
        let longtitude = String(coordinate.longitude)
        
        delegate?.fetchWeatherData(latitude: latitude, longtitude: longtitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
