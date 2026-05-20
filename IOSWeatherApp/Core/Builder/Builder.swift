//
//  Builder.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 13.04.2026.
//

import UIKit

final class Builder {
    
    static func makeSearchViewController() -> SearchViewController {
        let presenter = DIContainer.shared.makeSearchPresenter()
        let vc = SearchViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
    
    static func createPageViewController() -> PageViewController {
        PageViewController()
    }
    
    static func makeWeatherViewController(for city: CityModel) -> PageViewController {
        let vc = PageViewController()
        vc.initialCity = city
        return vc
    }
}
