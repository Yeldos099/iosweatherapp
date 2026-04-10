//
//  AppTextStyle.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 10.04.2026.
//

import UIKit

enum AppTextStyle {
    
    case cityName
    case temperature
    case weatherDescription
    case sectionTitle
    case hourly
    case sectionDescription
    
    
    var font: UIFont {
      switch self {
      case .cityName: return .systemFont(ofSize: 32, weight: .medium)
      case .temperature: return .systemFont(ofSize: 92, weight: .medium)
      case .weatherDescription: return .systemFont(ofSize: 18, weight: .medium)
      case .sectionTitle: return .systemFont(ofSize: 14)
      case .hourly: return .systemFont(ofSize: 15, weight: .medium)
      case .sectionDescription: return .systemFont(ofSize: 18, weight: .medium)
      
        }
    }
}


extension UILabel {
    func appTextStyle(_ style: AppTextStyle) {
        font = style.font
        textColor = UIColor(.textPrimary)
    }
}
