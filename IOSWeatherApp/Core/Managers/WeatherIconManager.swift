//
//  WeatherIconManager.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import UIKit

final class WeatherIconManager {
    
    static func icon(for weatherId: Int, isNight: Bool = false) -> UIImage? {
        switch weatherId {
        case 200...299:
            return UIImage(named: "rain2")
            case 300...399:
            return UIImage(named: "rain2")
            case 500...599:
            return UIImage(named: "rain2")
            case 600...699:
            return UIImage(named: "rain2")
            case 700...799:
            return UIImage(named: "cloud")
            case 800:
            return isNight ? UIImage(named: "moon") : UIImage(named: "sun")
            case 801...802:
            return isNight ? UIImage(named: "moon2") : UIImage(named: "sunset")
        case 803...804:
            return UIImage(named: "cloud")
        default:
            return UIImage(named: "sun")
        }
    }
}
