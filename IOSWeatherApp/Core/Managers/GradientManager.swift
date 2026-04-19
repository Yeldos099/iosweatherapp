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
    
    static func backGroundImage(for timeOfDay: TimeOfDay) -> UIImage? {
        switch timeOfDay {
        case .morning: return UIImage(named: "bgDay")
        case .day: return UIImage(named: "bgDay")
        case .evening: return UIImage(named: "bgEvening")
        case .night: return UIImage(named: "bgNight")
        }
    }
    
    static func gradientColors(for timeOfDay: TimeOfDay) -> [UIColor] {
        switch timeOfDay {
        case .morning:
            return [UIColor.black.withAlphaComponent(0.1),
                    UIColor.black.withAlphaComponent(0.4)]
            case .day:
            return [UIColor.black.withAlphaComponent(0.1),
                    UIColor.black.withAlphaComponent(0.3)]
        case .evening:
            return [UIColor.black.withAlphaComponent(0.2),
                    UIColor.black.withAlphaComponent(0.6)]
        case .night:
            return [UIColor.black.withAlphaComponent(0.3),
                    UIColor.black.withAlphaComponent(0.7)]
        }
    }
}
