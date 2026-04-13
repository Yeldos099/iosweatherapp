//
//  WeatherPresenter.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import Foundation
import CoreLocation

protocol MainViewPresenterProtocol: AnyObject {
    
}


final class MainViewPresenter: MainViewPresenterProtocol {
   
    private weak var view: MainViewProtocol?
    private let networkService: NetworkServiceProtocol
    private var locationManager: LocationManagerProtocol
    
    private let apiKey = "c18feebd5f6bce317baed061419aa3e5"
    
    init(view: MainViewProtocol? , networkService: NetworkServiceProtocol, locationManager: LocationManagerProtocol) {
        self.view = view
        self.networkService = networkService
        self.locationManager = locationManager
    }
    
    func viewDidLoad() {
        Task {
            await fetchLocation()
        }
    }
    
    private func fetchLocation() async {
        view?.showLoading()
        
        do {
            let coordinate = try await locationManager.requestLocation()
            print("Координаты: \(coordinate.latitude), \(coordinate.longitude)")
            await fetchWeather(coordinate: coordinate)
        } catch {
            await MainActor.run {
                view?.hideLoading()
                print("Ошибка геолокации \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWeather(coordinate: CLLocationCoordinate2D) async {
        
        do {
            guard let url = makeWeatherURL(lat: coordinate.latitude, lon: coordinate.longitude) else { return }
            let weather: WeatherResponse = try await networkService.request(url: url)
            
            await MainActor.run {
                view?.hideLoading()
                print(weather.name)
                print(weather.main.temp)
                print(weather.main.feelsLike)
                print(weather.main.humidity)
                print(weather.weather.first?.description ?? "")
            }
        } catch {
            await MainActor.run {
                view?.hideLoading()
            }
        }
    }
    
    private func makeWeatherURL(lat: Double, lon: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lon", value: "\(lon)"),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang", value: "ru")
        ]
        return components.url
            
    }
}
