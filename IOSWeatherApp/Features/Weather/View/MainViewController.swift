//
//  MainViewController.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import UIKit

protocol MainViewProtocol: AnyObject {
   func showLoading()
    func hideLoading()
}

final class MainViewController: UIViewController {
    
    
    var presenter: MainViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.WeatherBackground.sunnyDay
        presenter.viewDidLoad()
    }
}


extension MainViewController: MainViewProtocol {
    
    func showLoading() {
        print("Загрузка")
    }
    
    func hideLoading() {
        print("Загрузка завершена")
    }
    
    
}
