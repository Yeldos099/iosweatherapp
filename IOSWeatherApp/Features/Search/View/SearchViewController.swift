//
//  SearchViewController.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import UIKit
import MapKit

protocol SearchViewControllerProtocol: AnyObject {
    func showResults(_ results: [MKLocalSearchCompletion])
    func showSavedCities(_ cities: [CityModel])
    func showError(_ message: String)
    func showEmpty()
}


final class SearchViewController: UIViewController {
    
}
