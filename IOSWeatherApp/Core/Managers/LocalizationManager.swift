//
//  LocalizationManager.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 12.05.2026.
//

import Foundation


final class LocalizationManager {
    
    static let shared = LocalizationManager()
    
    private init() {}
    
    var usesMetricSystem: Bool {
        Locale.current.usesMetricSystem
    }
    
    func formatTemperature(_ celsius: Double) -> String {
        if usesMetricSystem {
            return "\(Int(celsius))°"
        } else {
            let fahrenheit = celsius * 9/5 + 32
            return "\(Int(fahrenheit))°"
        }
    }
    
    func formatWindSpeed(_ metersPerSecond: Double) -> String {
        if usesMetricSystem {
            let kmh = metersPerSecond * 3.6
            return "\(Int(kmh)) км/ч"
        } else {
            let mph = metersPerSecond * 2.237
            return "\(Int(mph)) mph"
        }
    }
}



