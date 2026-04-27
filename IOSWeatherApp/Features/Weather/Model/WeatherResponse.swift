//
//  WeatherResponse.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import Foundation


struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let pressure: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
        case pressure
    }
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}
