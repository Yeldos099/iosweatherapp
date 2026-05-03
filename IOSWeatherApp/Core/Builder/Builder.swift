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
        print("making search vc")
        let storage = DIContainer.shared.cityStorage
        print("storage ok")
        let presenter = SearchViewPresenter(storage: storage)
        print("presenter ok")
        let vc = SearchViewController(presenter: presenter)
        print("vc ok")
        presenter.view = vc
        return vc
    }
}
