//
//  WeatherViewModel.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 18.04.2026.
//

import Foundation


struct WeatherViewModel {
    let cityName: String
    let temperature: String
    let feelsLike: String
    let description: String
    let tempMin: String
    let tempMax: String
    let humidity: String
    let windSpeed: String
    let weatherId: Int
    let windDescription: String
    let feelsLikeDescription: String
    let windDirection: String
    let pressure: String
    let humidityDescription: String
    let pressureDescription: String
    let averageDescription: String
    let timeOfDay: TimeOfDay
    let sunsetTime: String
    let sunriseTime: String
    let uvIndex: Double
}
