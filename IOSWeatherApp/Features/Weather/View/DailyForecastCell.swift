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
        
        [dayLabel, minTempLabel, maxTempLabel].forEach {
            contentView.addSubview($0)
        }
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        maxTempLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        minTempLabel.snp.makeConstraints {
            $0.trailing.equalTo(maxTempLabel.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with model: DayForecast) {
        dayLabel.text = model.dayName
        minTempLabel.text = model.tempMin
        maxTempLabel.text = model.tempMax
    }
}
