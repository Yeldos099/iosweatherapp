//
//  ForecastResponse.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import Foundation


struct ForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: City
    
    struct City: Decodable {
        let name: String
    }
}


struct ForecastItem: Decodable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    let dtTxt: String
    
    
    struct Main: Decodable {
        let temp: Double
        let tempMin: Double
        let tempMax: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }
    
    struct Weather: Decodable {
        let id: Int
        let description: String
    }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case dtTxt = "dt_txt"
    }
}
