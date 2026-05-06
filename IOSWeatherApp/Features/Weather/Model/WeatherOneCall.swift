//
//  WeatherOneCall.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 06.05.2026.
//

import Foundation



import Foundation

struct OneCallResponse: Decodable {
    let current: CurrentWeather
    let daily: [DailyWeather]
    let hourly: [HourlyWeather]
    
    struct CurrentWeather: Decodable {
        let temp: Double
        let feelsLike: Double
        let humidity: Int
        let windSpeed: Double
        let uvi: Double
        let weather: [WeatherCondition]
        
        enum CodingKeys: String, CodingKey {
            case temp, humidity, uvi, weather
            case feelsLike = "feels_like"
            case windSpeed = "wind_speed"
        }
    }
    
    struct DailyWeather: Decodable {
        let dt: TimeInterval
        let temp: Temp
        let weather: [WeatherCondition]
        let uvi: Double
        
        struct Temp: Decodable {
            let min: Double
            let max: Double
        }
    }
    
    struct HourlyWeather: Decodable {
        let dt: TimeInterval
        let temp: Double
        let weather: [WeatherCondition]
    }
    
    struct WeatherCondition: Decodable {
        let id: Int
        let description: String
    }
}
