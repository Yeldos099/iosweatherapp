//
//  WeatherPresenter.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import Foundation
import CoreLocation

protocol MainViewPresenterProtocol: AnyObject {
    func viewDidLoad(city: CityModel?)
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
    
    private let apiKey = AppConstants.apiKey
    
    init(view: MainViewProtocol? , networkService: NetworkServiceProtocol, locationManager: LocationManagerProtocol) {
        self.view = view
        self.networkService = networkService
        self.locationManager = locationManager
    }
    
    func viewDidLoad(city: CityModel?) {
        Task {
            if let city = city {
                await fetchWeather(coordinate: CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude))
            } else {
                await fetchLocation()
            }
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
                  let forecastURL = makeForecastURL(lat: coordinate.latitude, lon: coordinate.longitude) else { return }
            
            async let weather: WeatherResponse = networkService.request(url: weatherURL)
            async let forecast: OneCallResponse = networkService.request(url: forecastURL)
            
            let (weatherResult, forecastResult) = try await (weather, forecast)
            let weatherViewmodel = WeatherMapper.map(from: weatherResult, uvIndex: forecastResult.current.uvi)
            let ForecastViewModel = ForecastMapper.map(from: forecastResult)
            
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
        components.path = "/data/3.0/onecall"
        components.queryItems = [
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lon", value: "\(lon)"),
            .init(name: "appid", value: AppConstants.apiKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang", value: "ru"),
            .init(name: "exclude", value: "minutely,alerts")
        ]
        return components.url
    }
}
