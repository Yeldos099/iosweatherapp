//
//  MainViewController.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
    @MainActor func showLoading()
    @MainActor func hideLoading()
    @MainActor func displayWeather(viewModel: WeatherViewModel)
    @MainActor func showError(message: String)
    @MainActor func stopRefreshing()
    @MainActor func displayForecast(viewModel: ForecastViewModel)
}

enum MainViewState {
    case loading
    case loaded
    case error(String)
}

final class MainViewController: UIViewController {
    
    
    var presenter: MainViewPresenterProtocol!
    
    lazy var backgroundImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    
    lazy var scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        return $0
    }(UIScrollView())
    
    lazy var contentView: UIView = {
        $0.backgroundColor = .clear
        return $0
    }(UIView())
    
    
    lazy var cityLabel: UILabel = {
        $0.appTextStyle(.cityName)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    
    lazy var temperatureLabel: UILabel = {
        $0.appTextStyle(.temperature)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    
    lazy var descriptionLabel: UILabel = {
        $0.appTextStyle(.weatherDescription)
        $0.textAlignment = .center
        $0.textColor = .textSecondary
        return $0
    }(UILabel())
    
    lazy var minMaxLabel: UILabel = {
        $0.appTextStyle(.sectionDescription)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        $0.style = .large
        $0.color = .white
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView())
    
    
    lazy var refreshControl: UIRefreshControl = {
        $0.tintColor = .white
        return $0
    }(UIRefreshControl())
    
    lazy var hourlyForecastView = HourlyForecastView()
    lazy var dailyForecastView = DailyForecastView()
    
    private var isGradientApplied: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated, )
        guard !isGradientApplied else { return }
        isGradientApplied = true
        print(backgroundImageView.bounds)
        let colors = GradientManager.gradientColors(for: GradientManager.timeOfDay())
        GradientManager.applyGradient(to: backgroundImageView, colors: colors)
    }
    
    private func setupUI() {
        setupBackground()
        setupScrollView()
        setupTopSection()
        setupHourlySection()
        setupDailySection()
        setupActivityIndicator()
    }
    
    private func setupBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
        }
        
        backgroundImageView.image = GradientManager.backGroundImage(for: GradientManager.timeOfDay())
        
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
    }
    
    private func setupTopSection() {
        [cityLabel, temperatureLabel, descriptionLabel, minMaxLabel].forEach {
            contentView.addSubview($0)
        }
        
        cityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(-15)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        minMaxLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    
    private func setupHourlySection() {
        contentView.addSubview(hourlyForecastView)
        
        hourlyForecastView.snp.makeConstraints {
            $0.top.equalTo(minMaxLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(170)
        }
    }
    
    private func setupDailySection() {
        contentView.addSubview(dailyForecastView)
        
        dailyForecastView.snp.makeConstraints {
            $0.top.equalTo(hourlyForecastView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44 * 5 + 44)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
   
    
    @MainActor
    private func updateState(_ state: MainViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            scrollView.isHidden = true
        case .loaded:
            activityIndicator.stopAnimating()
            scrollView.isHidden = false
        case .error(let message):
            activityIndicator.stopAnimating()
            scrollView.isHidden = true
            print(message)
        }
    }
   
    
    
    
   
    
   @objc private func handleRefresh(){
       presenter.refresh()
    }
}


extension MainViewController: MainViewProtocol {
    
    func displayForecast(viewModel: ForecastViewModel) {
        hourlyForecastView.configure(with: viewModel.hourly)
        dailyForecastView.configure(with: viewModel.daily, globalMin: viewModel.globalMinTemp, globalMax: viewModel.globalMaxTemp)
    }
    
    
    func stopRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    
    func showLoading() {
        updateState(.loading)
    }
    
    func hideLoading() {
        updateState(.loaded)
    }
    
    func showError(message: String) {
        updateState(.error(message))
    }
    
    func displayWeather(viewModel: WeatherViewModel) {
        cityLabel.text = viewModel.cityName
        temperatureLabel.text = viewModel.temperature
        descriptionLabel.text = viewModel.description
        minMaxLabel.text = "Макс: \(viewModel.tempMax) Мин: \(viewModel.tempMin)"
        hourlyForecastView.configureWind(with: viewModel.windDescription)
    }
}
