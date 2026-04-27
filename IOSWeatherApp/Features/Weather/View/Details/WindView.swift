//
//  WindView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 24.04.2026.
//

import UIKit
import SnapKit

final class WindView: UIView {
    
    lazy var iconImageView: UIImageView = {
        $0.image = .wind
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    lazy var titleLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        $0.text = "ВЕТЕР"
        return $0
    }(UILabel())
    
    lazy var windLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        $0.text = "Ветер"
        return $0
    }(UILabel())
    
    lazy var windValueLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        return $0
    }(UILabel())
    
    
    lazy var gustLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        $0.text = "Порывы ветра"
        return $0
    }(UILabel())
    
    lazy var gustValueLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        return $0
    }(UILabel())
    
    lazy var directionLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        $0.text = "Направление"
        return $0
    }(UILabel())
    
    lazy var directionValueLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        return $0
    }(UILabel())
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        GradientManager.applyGradient(to: self, colors: GradientManager.gradientColors(for: GradientManager.timeOfDay()))
        layer.cornerRadius = 16
        clipsToBounds = true
    }
    
    private func setupUI() {
                
                [iconImageView, titleLabel, windLabel, windValueLabel,
                 gustLabel, gustValueLabel, directionLabel, directionValueLabel].forEach {
                    addSubview($0)
                }
                
                iconImageView.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(12)
                    $0.leading.equalToSuperview().offset(16)
                    $0.width.height.equalTo(16)
                }
                
                titleLabel.snp.makeConstraints {
                    $0.centerY.equalTo(iconImageView)
                    $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
                }
                
                windLabel.snp.makeConstraints {
                    $0.top.equalTo(iconImageView.snp.bottom).offset(12)
                    $0.leading.equalToSuperview().offset(16)
                }
                
                windValueLabel.snp.makeConstraints {
                    $0.centerY.equalTo(windLabel)
                    $0.trailing.equalToSuperview().inset(16)
                }
                
                gustLabel.snp.makeConstraints {
                    $0.top.equalTo(windLabel.snp.bottom).offset(8)
                    $0.leading.equalToSuperview().offset(16)
                }
                
                gustValueLabel.snp.makeConstraints {
                    $0.centerY.equalTo(gustLabel)
                    $0.trailing.equalToSuperview().inset(16)
                }
                
                directionValueLabel.snp.makeConstraints {
                    $0.centerY.equalTo(directionLabel)
                    $0.trailing.equalToSuperview().inset(16)
                }
        
                directionLabel.snp.makeConstraints {
                    $0.top.equalTo(gustLabel.snp.bottom).offset(8)
                    $0.leading.equalToSuperview().offset(16)
                    $0.bottom.equalToSuperview().inset(12)
                }
            }
            
            func configure(with viewModel: WeatherViewModel) {
                windValueLabel.text = viewModel.windSpeed
                gustValueLabel.text = viewModel.windDescription
                directionValueLabel.text = viewModel.windDirection
            }
    }

