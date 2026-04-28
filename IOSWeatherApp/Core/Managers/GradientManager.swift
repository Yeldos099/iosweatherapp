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
    case sunrise
    case sunset
    
    static func current(now: Date, sunrise: Date, sunset: Date) -> TimeOfDay {
        let sunriseEnd = sunrise.addingTimeInterval(3600)
        let sunsetStart = sunset.addingTimeInterval(-3600)
        
        if now < sunrise  { return .night }
        if now < sunriseEnd { return .sunrise }
        if now < sunsetStart { return .day }
        if now < sunset { return .sunset }
        return .night
    }
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
        case .morning: return UIImage(named: "bgMorning")
        case .day: return UIImage(named: "bgDay")
        case .evening: return UIImage(named: "bgEvening")
        case .night: return UIImage(named: "bgNight")
        case .sunrise: return UIImage(named: "bgMorning")
        case .sunset: return UIImage(named: "bgEvening")
        }
    }
    
    static func gradientColors(for timeOfDay: TimeOfDay) -> [UIColor] {
        switch timeOfDay {
        case .morning:
            return [AppColor.WeatherBackground.cloudy.withAlphaComponent(0.3),
                    AppColor.WeatherBackground.cloudy.withAlphaComponent(0.7)]
            case .day:
            return [AppColor.WeatherBackground.sunnuDeep.withAlphaComponent(0.2),
                    AppColor.WeatherBackground.sunnuDeep.withAlphaComponent(0.6)]
        case .evening:
            return [AppColor.WeatherBackground.rainyDark.withAlphaComponent(0.4),
                    AppColor.WeatherBackground.rainyDark.withAlphaComponent(0.8)]
        case .night:
            return [AppColor.WeatherBackground.night.withAlphaComponent(0.3),
                    AppColor.WeatherBackground.night.withAlphaComponent(0.6)]
        case .sunrise:
            return [AppColor.WeatherBackground.sunnyDay.withAlphaComponent(0.3),
                AppColor.WeatherBackground.sunnyDay.withAlphaComponent(0.7)]
        case .sunset:
            return [AppColor.WeatherBackground.cloudy.withAlphaComponent(0.3),
                    AppColor.WeatherBackground.cloudy.withAlphaComponent(0.7)]
        }
    }
    
    static func applyGradient(to view: UIView, colors: [UIColor]) {
        view.layer.sublayers?
            .filter { $0 is CAGradientLayer }
            .forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = .init(x: 0.5, y: 0)
        gradient.endPoint = .init(x: 0.5, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
//        view.layer.cornerRadius = 16
    }
}
