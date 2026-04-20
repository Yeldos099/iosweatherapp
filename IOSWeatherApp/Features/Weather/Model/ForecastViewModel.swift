//
//  ForecastViewModel.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import Foundation


struct ForecastViewModel {
    let daily: [DayForecast]
    let hourly: [HourForecast]
}

struct DayForecast {
    let dayName: String
    let tempMin: String
    let tempMax: String
    let weatherID: Int
}

struct HourForecast {
    let time: String
    let temp: String
    let weatherId: Int
}
