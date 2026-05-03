//
//  SearchPresenter.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import Foundation
import MapKit

protocol SearchViewPresenterProtocol {
    func viewDidLoad()
    func search(query: String)
    func selectCity(_ completion: MKLocalSearchCompletion)
    func removeCity(at index: Int)
}


final class SearchViewPresenter: SearchViewPresenterProtocol {
    
    
    weak var view: SearchViewControllerProtocol?
    
    private let storage: CityStorageProtocol
    private let networkService: NetworkServiceProtocol
    private let locationManager: LocationManagerProtocol
    private var searchCompleter = MKLocalSearchCompleter()
    private let completerDelegate = SearchCompleterDelegate()
    private var debounceTimer: Timer?
    
    
    init(storage: CityStorageProtocol, networkService: NetworkServiceProtocol, locationManager: LocationManagerProtocol){
        self.storage = storage
        self.networkService = networkService
        self.locationManager = locationManager
        setupCompleter()
    }
    
    private func setupCompleter() {
        searchCompleter.delegate = completerDelegate
        searchCompleter.resultTypes = .address
        
        completerDelegate.onResults = { [weak self] results in
            self?.view?.showResults(results)
        }
        
        completerDelegate.onError = { [weak self] error in
            self?.view?.showError(error.localizedDescription)
        }
    }
    
    func viewDidLoad() {
        let cities = storage.load()
        view?.showSavedCities(cities)
        Task { await fetchCurrentLocation() }
    }
    
    private func fetchCurrentLocation() async {
        do {
            let coordinate = try await locationManager.requestLocation()
            await fetchWeatherAndSave(cityName: nil, latitude: coordinate.latitude, longitude: coordinate.longitude, isCurrentLocation: true)
        } catch {
            //
        }
    }
    
    func search(query: String) {
        debounceTimer?.invalidate()
        
        guard !query.isEmpty else {
            view?.showEmpty()
            return
        }
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            self?.searchCompleter.queryFragment = query
        }
    }
    
    func selectCity(_ completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] response, error in
            guard let self, let item = response?.mapItems.first else { return }
            
            Task{
                await self.fetchWeatherAndSave(cityName: completion.title, latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude, isCurrentLocation: false)
            }
        }
    }
    
    private func fetchWeatherAndSave(cityName: String?, latitude: Double, longitude: Double, isCurrentLocation: Bool) async {
        guard let url = makeWeatherURL(lat: latitude, lon: longitude) else {
            return }
        do {
            let response: WeatherResponse = try await networkService.request(url: url)
            let name = cityName ?? response.name
            let city = CityModel(
                cityName: name,
                latitude: latitude,
                longitude: longitude,
                description: response.weather.first?.description,
                tempMax: "\(Int(response.main.tempMax))°",
                tempMin: "\(Int(response.main.tempMin))°",
                temperature: "\(Int(response.main.temp))°",
                isCurrentLocation: isCurrentLocation)
            updateStorage(city: city, isCurrentLocation: isCurrentLocation)
            
        } catch {
            if !isCurrentLocation {
                let city = CityModel(cityName: cityName ?? "",
                                     latitude: latitude,
                                     longitude: longitude,
                                     isCurrentLocation: false)
                storage.add(city: city)
            }
        }
        await MainActor.run {
            view?.showSavedCities(storage.load())
        }
    }
    
    private func updateStorage(city: CityModel, isCurrentLocation: Bool) {
        print("cities after save \(storage.load().map { $0.cityName})")
        if isCurrentLocation {
            var cities = storage.load()
            if let index = cities.firstIndex(where: { $0.isCurrentLocation }) {
                cities[index] = city
            } else {
                cities.insert(city, at: 0)
            }
            storage.save(cities: cities)
        } else {
            storage.add(city: city)
        }
    }
    
    func removeCity(at index: Int) {
        storage.remove(at: index)
        view?.showSavedCities(storage.load())
    }
    
    private func makeWeatherURL(lat: Double, lon: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            .init(name: "lat", value: "\(lat)"),
            .init(name: "lon", value: "\(lon)"),
            .init(name: "appid", value: AppConstants.apiKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang", value: "ru")
        ]
        return components.url
    }
}
