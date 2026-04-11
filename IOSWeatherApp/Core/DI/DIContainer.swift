//
//  DIContainer.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import Foundation

final class DIContainer {
    
    static let shared = DIContainer()
    private init() {}
    
    lazy var networkService: NetworkServiceProtocol = {
        NetworkService()
    }()
    
    lazy var locationManager: LocationManagerProtocol = {
        LocationManager()
    }()
    
}
