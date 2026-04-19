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
        view?.showLoading()
        
        do {
            let coordinate = try await locationManager.requestLocation()
            print("Координаты: \(coordinate.latitude), \(coordinate.longitude)")
            await fetchWeather(coordinate: coordinate)
        } catch {
            await MainActor.run {
                view?.showError(message: error.localizedDescription)
                
            }
        }
    }
    
    func fetchWeather(coordinate: CLLocationCoordinate2D) async {
        
        do {
            guard let url = makeWeatherURL(lat: coordinate.latitude, lon: coordinate.longitude) else { return }
            let weather: WeatherResponse = try await networkService.request(url: url)
            let viewmodel = WeatherMapper.map(from: weather)
            
            await MainActor.run {
                view?.hideLoading()
                view?.stopRefreshing()
                view?.displayWeather(viewModel: viewmodel)
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
}
