//
//  HumidityPressureView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 24.04.2026.
//

import UIKit
import SnapKit

final class HumidityPressureView: UIView {
    
    
    lazy var humidityBlock = DetailBlockView(icon: "humidity", title: "ВЛАЖНОСТЬ")
    lazy var pressureBlock = DetailBlockView(icon: "squeeze", title: "ДАВЛЕНИЕ")
    
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [humidityBlock, pressureBlock])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: WeatherViewModel) {
        humidityBlock.configure(value: viewModel.humidity, description: viewModel.humidityDescription, subtitle: nil)
        pressureBlock.configure(value: viewModel.pressure, description: viewModel.pressureDescription, subtitle: nil)
    }
}
