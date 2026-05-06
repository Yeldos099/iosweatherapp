//
//  ForecastMapper.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import Foundation

final class ForecastMapper {
    
    static func map(from response: OneCallResponse) -> ForecastViewModel {
        let hourly = mapHourly(from: response.hourly)
        let daily = mapDaily(from: response.daily)
        
        let globalMin = response.daily.map { $0.temp.min }.min() ?? 0
        let globalMax = response.daily.map { $0.temp.max }.max() ?? 0
        
        
        return ForecastViewModel(daily: daily, hourly: hourly,globalMinTemp: globalMin, globalMaxTemp: globalMax)
    }
    
    private static func mapHourly(from items: [OneCallResponse.HourlyWeather]) -> [HourForecast] {
        return items.prefix(8).enumerated().map { index,item in
            HourForecast(time: index == 0 ? "Сейчас" : formatHour(from: item.dt),
                         temp: "\(Int(item.temp))°",
                         weatherId: item.weather.first?.id ?? 800)
        }
    }
    
    private static func mapDaily(from items: [OneCallResponse.DailyWeather]) -> [DayForecast] {
        return items.prefix(8).compactMap{
            item in
            DayForecast(dayName: formatDay(from: item.dt),
                        tempMin: "\(Int(item.temp.min))°",
                        tempMax: "\(Int(item.temp.max))°",
                        tempMinValue: item.temp.min,
                        tempMaxValue: item.temp.max,
                        weatherId: item.weather.first?.id ?? 800)
        }
    }
    
    private static func formatHour(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private static func formatDay(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).capitalized
    }
}
