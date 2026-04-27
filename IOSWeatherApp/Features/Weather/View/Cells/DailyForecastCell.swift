//
//  DailyForecastCell.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import UIKit
import SnapKit

final class DailyForecastCell: UITableViewCell {
    
    static let identifier = "DailyForecastCell"
    
    lazy var dayLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        return $0
    }(UILabel())
    
    lazy var minTempLabel: UILabel = {
        $0.appTextStyle(.sectionDescription)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    
    lazy var maxTempLabel: UILabel = {
        $0.appTextStyle(.sectionDescription)
        $0.textAlignment = .right
        return $0
    }(UILabel())
    
    lazy var iconImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        return $0
    }(UIImageView())
    
    lazy var temperatureRangeView: TemperatureRangeView = {
        return $0
    }(TemperatureRangeView())
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [dayLabel, minTempLabel, maxTempLabel, iconImageView, temperatureRangeView].forEach {
            contentView.addSubview($0)
        }
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalTo(dayLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        
        maxTempLabel.snp.makeConstraints {
            $0.leading.equalTo(temperatureRangeView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        minTempLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(36)
        }
        
        temperatureRangeView.snp.makeConstraints {
            $0.leading.equalTo(minTempLabel.snp.trailing).offset(6)
            $0.trailing.equalTo(maxTempLabel.snp.leading).offset(-6)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(4)
        }
    }
    
    func configure(with model: DayForecast, globalMin: Double, globalMax: Double) {
        dayLabel.text = model.dayName
        minTempLabel.text = model.tempMin
        maxTempLabel.text = model.tempMax
        iconImageView.image = WeatherIconManager.icon(for: model.weatherId)
        temperatureRangeView.configure(minTemp: model.tempMinValue, maxTemp: model.tempMaxValue, globalMin: globalMin, globalMax: globalMax)
    }
}
