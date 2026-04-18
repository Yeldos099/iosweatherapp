//
//  LocationManager.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import CoreLocation

protocol LocationManagerProtocol: AnyObject {
    func requestLocation() async throws -> CLLocationCoordinate2D
}


final class LocationManager: NSObject, LocationManagerProtocol {
    
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocation() async throws -> CLLocationCoordinate2D {
        switch manager.authorizationStatus {
        case .denied, .restricted:
            throw LocationError.denied
        case .notDetermined, .authorizedWhenInUse, .authorizedAlways:
            break
            @unknown default:
            throw LocationError.unknown
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            switch manager.authorizationStatus {
                case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
                default :
                break
            }
        }
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        print("Координаты: \(coordinate.latitude), \(coordinate.longitude)")
        continuation?.resume(returning: coordinate)
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: LocationError.failed(error.localizedDescription))
        continuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            case .denied:
            continuation?.resume(throwing: LocationError.denied)
            continuation = nil
        default:
            break
        }
    }
}


