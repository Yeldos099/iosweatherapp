//
//  ForecastMapper.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import Foundation

final class ForecastMapper {
    
    static func map(from response: ForecastResponse) -> ForecastViewModel {
        let hourly = mapHourly(from: response.list)
        let daily = mapDaily(from: response.list)
        
        let globalMin = response.list.map { $0.main.tempMin }.min() ?? 0
        let globalMax = response.list.map { $0.main.tempMax }.max() ?? 0
        
        
        return ForecastViewModel(daily: daily, hourly: hourly,globalMinTemp: globalMin, globalMaxTemp: globalMax)
    }
    
    private static func mapHourly(from items: [ForecastItem]) -> [HourForecast] {
        return items.prefix(8).enumerated().map {index,item in
            HourForecast(time: index == 0 ? "Сейчас" : formatHour(from: item.dt),
                         temp: "\(Int(item.main.temp))°",
                         weatherId: item.weather.first?.id ?? 800)
        }
    }
    
    private static func mapDaily(from items: [ForecastItem]) -> [DayForecast] {
        var grouped: [String: [ForecastItem]] = [:]
        for item in items {
            let day = String(item.dtTxt.prefix(10))
            grouped[day, default: []].append(item)
        }
        
        return grouped.keys.sorted().prefix(8).compactMap { day -> DayForecast? in
            guard let dayItems = grouped[day] else { return nil }
            let minTemp = dayItems.map{ $0.main.tempMin }.min() ?? 0
            let maxTemp = dayItems.map{ $0.main.tempMax }.max() ?? 0
            let weatherId = dayItems.first?.weather.first?.id ?? 800
            
            return DayForecast(dayName: formatDay(from: day), tempMin: "\(Int(minTemp))°", tempMax: "\(Int(maxTemp))°", tempMinValue: minTemp, tempMaxValue: maxTemp, weatherId: weatherId)
        }
    }
    private static func formatHour(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    private static func formatDay(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ru_RU")
        outputFormatter.dateFormat = "EEE"
        return outputFormatter.string(from: date).capitalized
    }
}
