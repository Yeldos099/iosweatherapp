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
        let presenter = DIContainer.shared.makeMainPresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    static func makeSearchViewController() -> SearchViewController {
        let presenter = DIContainer.shared.makeSearchPresenter()
        let vc = SearchViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
    
    static func createPageViewController() -> PageViewController {
        PageViewController()
    }
}
