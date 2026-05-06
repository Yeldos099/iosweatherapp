//
//  CityCell.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 03.05.2026.
//

import UIKit
import SnapKit
import MapKit

final class CityCell: UITableViewCell {
    
    static let reuseIdentifier = "CityCell"
    
    private lazy var containerView: UIView = {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private lazy var backgroundImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var cityNameLabel: UILabel = {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var subtitleLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .textSecondary
        return $0
    }(UILabel())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .textSecondary
        return $0
    }(UILabel())
    
    private lazy var temperatureLabel: UILabel = {
        $0.font = .systemFont(ofSize: 48, weight: .medium)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var minMaxLabel: UILabel = {
        $0.font = .systemFont(ofSize: 10, weight: .bold)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        
        [cityNameLabel, subtitleLabel, descriptionLabel, temperatureLabel, minMaxLabel].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        cityNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualTo(temperatureLabel.snp.leading).offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(cityNameLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualTo(temperatureLabel.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualTo(minMaxLabel.snp.leading).offset(-8)
        }
        
        minMaxLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with city: CityModel) {
        backgroundImageView.image = GradientManager.backGroundImage(for: GradientManager.timeOfDay())
        cityNameLabel.text = city.cityName
        subtitleLabel.text = city.isCurrentLocation ? "Текущее место" : "15:58"
        descriptionLabel.text = city.description
        temperatureLabel.text = city.temperature
        minMaxLabel.text = city.tempMax != nil ? "Макс: \(city.tempMax!) Мин: \(city.tempMin!)" : nil
    }
    
    func configureSearch(with result: MKLocalSearchCompletion) {
        backgroundImageView.image = GradientManager.backGroundImage(for: GradientManager.timeOfDay())
        cityNameLabel.text = result.title
        subtitleLabel.text = result.subtitle
        descriptionLabel.text = nil
        temperatureLabel.text = nil
        minMaxLabel.text = nil
    }
}
