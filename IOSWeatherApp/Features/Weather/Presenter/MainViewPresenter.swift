//
//  WeatherPresenter.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import Foundation
import CoreLocation

protocol MainViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func refresh()
}


final class MainViewPresenter: MainViewPresenterProtocol {
    
    func refresh() {
        Task {
            await fetchLocation()
        }
    }
    
   
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
        await view?.showLoading()
        
        do {
            let coordinate = try await locationManager.requestLocation()
            await fetchWeather(coordinate: coordinate)
        } catch {
            await MainActor.run {
                view?.showError(message: error.localizedDescription)
                
            }
        }
    }
    
    func fetchWeather(coordinate: CLLocationCoordinate2D) async {
        
        do {
            guard let weatherURL = makeWeatherURL(lat: coordinate.latitude, lon: coordinate.longitude),
                  let forecastURL = makeForecastURL(lat: coordinate.latitude, lon: coordinate.longitude),
            let uvURL = makeUVURL(lat: coordinate.latitude, lon: coordinate.longitude) else { return }
            
            async let weather: WeatherResponse = networkService.request(url: weatherURL)
            async let forecast: ForecastResponse = networkService.request(url: forecastURL)
            async let uv: UVResponse = networkService.request(url: uvURL)
            
            let (weatherResult, forecastResult, uvResult) = try await (weather, forecast, uv)
            let weatherViewmodel = WeatherMapper.map(from: weatherResult, uvResponse: uvResult)
            let ForecastViewModel = ForecastMapper.map(from: forecastResult)
            print("прогноз \(forecastResult.list.count)")
            
            await MainActor.run {
                view?.hideLoading()
                view?.stopRefreshing()
                view?.displayWeather(viewModel: weatherViewmodel)
                view?.displayForecast(viewModel: ForecastViewModel)
            }
        } catch {
            await MainActor.run {
                view?.showError(message: error.localizedDescription)
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
    
    private func makeForecastURL(lat: Double, lon: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lon", value: "\(lon)"),
            .init(name: "appid", value: apiKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang", value: "ru")
            ]
        return components.url
    }
    
    
    private func makeUVURL(lat: Double, lon: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/uvi"
        components.queryItems = [
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lon", value: "\(lon)"),
            .init(name: "appid", value: apiKey)
        ]
        return components.url
    }
}
