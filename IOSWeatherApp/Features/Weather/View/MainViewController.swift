//
//  MainViewController.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 11.04.2026.
//

import UIKit
import SnapKit

protocol MainViewProtocol: AnyObject {
   func showLoading()
    func hideLoading()
}

final class MainViewController: UIViewController {
    
    
    var presenter: MainViewPresenter!
    
    lazy var backgroundImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var gradientLayer: CAGradientLayer = {
        $0.startPoint = CGPoint(x: 0.5, y: 0)
        $0.endPoint = CGPoint(x: 0.5, y: 1)
        return $0
    }(CAGradientLayer())
    
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
        return $0
    }(UILabel())
    
    lazy var minMaxLabel: UILabel = {
        $0.appTextStyle(.sectionDescription)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        setupBackground()
        setupScrollView()
        setupTopSection()
    }
    
    private func setupBackground(){
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
        }
        
        gradientLayer.colors = GradientManager.gradientColors(for: GradientManager.timeOfDay()).map{ $0.cgColor }
        backgroundImageView.layer.addSublayer(gradientLayer)
        
        backgroundImageView.image = GradientManager.backGroundImage(for: GradientManager.timeOfDay())
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
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
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(cityLabel.snp.bottom).offset(8)
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
}


extension MainViewController: MainViewProtocol {
    
    func showLoading() {
        print("Загрузка")
    }
    
    func hideLoading() {
        print("Загрузка завершена")
    }
    
    
}
