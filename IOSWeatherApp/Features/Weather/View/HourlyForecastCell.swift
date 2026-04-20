//
//  HourlyForecastCell.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import UIKit
import SnapKit

final class HourlyForecastCell: UICollectionViewCell {
    
    static let identifier: String = "HourlyForecastCell"
    
    lazy var timeLabel: UILabel = {
        $0.appTextStyle(.hourly)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy var tempLabel: UILabel = {
        $0.appTextStyle(.hourly)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy var iconImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [timeLabel, tempLabel, iconImageView].forEach {
            contentView.addSubview($0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        tempLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with model: HourForecast) {
        timeLabel.text = model.time
        tempLabel.text = model.temp
        iconImageView.image = WeatherIconManager.icon(for: model.weatherId)
    }
}
