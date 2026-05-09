//
//  PageViewController.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 09.05.2026.
//

import UIKit

final class PageViewController: UIViewController {
    
    private var cities: [CityModel] = []
    private var currentIndex: Int = 0
    
    private lazy var pageVC: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
        loadCities()
    }
    
    private func setupPageVC() {
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
    }
    
    private func loadCities(){
        cities = DIContainer.shared.cityStorage.load()
        guard !cities.isEmpty else { return }
        let firstVC = makeWeatherVC(for: 0)
        pageVC.setViewControllers([firstVC], direction: .forward, animated: false)
    }
    
    private func makeWeatherVC(for index: Int) -> MainViewController {
        let vc = MainViewController()
        let presenter = DIContainer.shared.makeMainPresenter(view: vc)
        vc.presenter = presenter
        vc.city = cities[index]
        return vc
    }
}


extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? MainViewController,
              let city = vc.city,
              let index = cities.firstIndex(where: { $0.cityName == city.cityName }),
              index > 0 else { return nil }
        return makeWeatherVC(for: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? MainViewController,
              let city = vc.city,
              let index = cities.firstIndex(where: { $0.cityName == city.cityName }),
              index < cities.count - 1 else { return nil }
        return makeWeatherVC(for: index + 1)
    }
}


extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let vc = pageViewController.viewControllers?.first as? MainViewController,
              let city = vc.city,
              let index = cities.firstIndex(where: { $0.cityName == city.cityName }) else { return }
        currentIndex = index
    }
}
