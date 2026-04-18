//
//  GradientManager.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 18.04.2026.
//

import UIKit

enum TimeOfDay {
    case morning
    case day
    case evening
    case night
}


final class GradientManager {
    static func timeOfDay() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return .morning
        case 12..<18: return .day
        case 18..<22: return .evening
        default: return .night
        }
    }
    
    static func gradientColors(for timeOfDay: TimeOfDay) -> [UIColor] {
        switch timeOfDay {
        case .morning:
            return []
        }
    }
}
