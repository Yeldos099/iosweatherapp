//
//  WeatherMapper.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 18.04.2026.
//

import Foundation


final class WeatherMapper {
    static func map(from response: WeatherResponse, uvResponse: UVResponse) -> WeatherViewModel {
        let sunrise = Date(timeIntervalSince1970: response.sys.sunrise)
        let sunset = Date(timeIntervalSince1970: response.sys.sunset)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current
        let timeOfDay = TimeOfDay.current(now: Date(), sunrise: sunrise, sunset: sunset)
        return WeatherViewModel(cityName: response.name,
                                temperature: "\(Int(response.main.temp))°",
                                feelsLike: "\(Int(response.main.feelsLike))°",
                                description: response.weather.first?.description ?? "",
                                tempMin: "\(Int(response.main.tempMin))°",
                                tempMax: "\(Int(response.main.tempMax))°",
                                humidity: "\(response.main.humidity)%",
                                windSpeed: "\(Int(response.wind.speed)) м/с",
                                weatherId: response.weather.first?.id ?? 800,
                                windDescription: "\(Int(response.wind.speed * 3.6)) км/ч)", feelsLikeDescription: response.main.feelsLike > response.main.temp ?
                                "По ощущениям теплее, чем на самом деле." :
                                    "По ощущениям холоднее, чем на самом деле.", windDirection: "\(response.wind.deg)°",
                                pressure: "\(response.main.pressure) гПА",
                                humidityDescription: "Точка росы сейчас: \(Int(response.main.tempMin))°",
                                pressureDescription: "↓ гПА",
                                averageDescription: "Сегодня Макс.: \(Int(response.main.tempMax))", timeOfDay: timeOfDay, sunsetTime: formatter.string(from: sunset), sunriseTime: formatter.string(from: sunrise), uvIndex: uvResponse.value)
    }
}
