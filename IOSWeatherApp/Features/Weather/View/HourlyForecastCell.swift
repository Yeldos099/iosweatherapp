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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [timeLabel, tempLabel].forEach {
            contentView.addSubview($0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with model: HourForecast) {
        timeLabel.text = model.time
        tempLabel.text = model.temp
    }
}
