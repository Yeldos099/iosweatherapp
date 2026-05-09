//
//  CityModel.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import Foundation


struct CityModel: Codable {
    let cityName: String
    let latitude: Double
    let longitude: Double
    var description: String?
    var tempMax: String?
    var tempMin: String?
    var temperature: String?
    let isCurrentLocation: Bool
}


extension CityModel: Equatable {
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        lhs.cityName == rhs.cityName && lhs.latitude == rhs.latitude
    }
}
