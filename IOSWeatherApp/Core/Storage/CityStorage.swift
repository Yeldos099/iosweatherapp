//
//  CityStorage.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import Foundation


final class CityStorage {
    
    private let key = "savedCities"
    private let defaults = UserDefaults.standard
    
    func save(cities: [CityModel]){
        let data = try? JSONEncoder().encode(cities)
        defaults.set(data, forKey: key)
    }
    
    func load() -> [CityModel] {
        guard let data = defaults.data(forKey: key),
              let cities = try? JSONDecoder().decode([CityModel].self, from: data) else {
            return []
        }
        return cities
    }
    
    func add(city: CityModel){
        var cities = load()
        cities.append(city)
        save(cities: cities)
    }
    
    func remove(at index: Int){
        var cities = load()
        cities.remove(at: index)
        save(cities: cities)
    }
}
