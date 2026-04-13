//
//  Builder.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 13.04.2026.
//

import UIKit

final class Builder {
    
    static func createViewController() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewPresenter(view: view, networkService: DIContainer.shared.networkService, locationManager: DIContainer.shared.locationManager)
        view.presenter = presenter
        return view
    }
}
