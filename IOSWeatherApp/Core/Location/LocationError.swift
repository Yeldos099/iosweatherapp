//
//  LocationError.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import Foundation


enum LocationError: LocalizedError {
    case denied
    case failed(String)
    case unknown
    
    
    var errorDescription: String? {
        switch self {
        case .denied:
            return "Доступ к локации запрещен. Разрешите в настройках"
        case .failed(let message):
            return "Ошибка геолокации: \(message)"
        case .unknown:
            return "Неизвестная ошибка геолокации"
        }
    }
}
