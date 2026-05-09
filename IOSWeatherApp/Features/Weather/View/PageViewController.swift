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
    
    private lazy var bottomStackView: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    private lazy var mapBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .tabbarMap
        config.contentInsets = .zero
        $0.configuration = config
        $0.tintColor = .white
        return $0
    }(UIButton())
    
    private lazy var indicatorView = PageIndicatorView()
    
    private lazy var detailsBtn: UIButton = {
        $0.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return $0
    }(UIButton())
    
    private lazy var listBtn: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = .tabbarList
        config.contentInsets = .zero
        $0.configuration = config
        $0.tintColor = .white
        $0.addAction(UIAction { [weak self] _ in
            let vc = Builder.makeSearchViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageVC()
        setupBottomBar()
        loadCities()
    }
    
    private func setupPageVC() {
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
    }
    
    private func setupBottomBar() {
        [mapBtn, detailsBtn, listBtn].forEach {
            bottomStackView.addArrangedSubview( $0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(44)
            }
        }
        
        view.addSubview(bottomStackView)
        bottomStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
    }
    private func loadCities(){
        cities = DIContainer.shared.cityStorage.load()
        guard !cities.isEmpty else { return }
        indicatorView.configure(count: cities.count, currentIndex: 0)
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
        indicatorView.update(currentIndex: index)
    }
}
