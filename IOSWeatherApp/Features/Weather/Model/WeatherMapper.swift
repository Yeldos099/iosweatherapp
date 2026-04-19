//
//  WeatherMapper.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 18.04.2026.
//

import Foundation


final class WeatherMapper {
    static func map(from response: WeatherResponse) -> WeatherViewModel {
        return WeatherViewModel(cityName: response.name,
                                temperature: "\(Int(response.main.temp))°",
                                feelsLike: "Ощущается как \(Int(response.main.feelsLike))",
                                description: response.weather.first?.description ?? "",
                                tempMin: "\(Int(response.main.tempMin))°",
                                tempMax: "\(Int(response.main.tempMax))°",
                                humidity: "\(response.main.humidity)%",
                                windSpeed: "\(Int(response.wind.speed)) м/с",
                                weatherId: response.weather.first?.id ?? 800)
    }
}
