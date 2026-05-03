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
    private var searchCompleter = MKLocalSearchCompleter()
    private let completerDelegate = SearchCompleterDelegate()
    private var debounceTimer: Timer?
    
    init(storage: CityStorageProtocol){
        self.storage = storage
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
            guard let item = response?.mapItems.first else { return }
            let city = CityModel(cityName: completion.title,
                                 latitude: item.placemark.coordinate.latitude,
                                 longitude: item.placemark.coordinate.longitude,
                                 isCurrentLocation: false)
            self?.storage.add(city: city)
            DispatchQueue.main.async {
                let cities = self?.storage.load() ?? []
                self?.view?.showSavedCities(cities)
            }
        }
    }
    
    func removeCity(at index: Int) {
        storage.remove(at: index)
        let cities = storage.load()
        view?.showSavedCities(cities)
    }
}
