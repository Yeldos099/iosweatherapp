//
//  DetailsView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 24.04.2026.
//

import UIKit
import SnapKit

final class DetailsView: UIView {
    
    
    lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .fill
        return $0
    }(UIStackView())
    
    lazy var averageFeelsView = AverageFeelsView()
    lazy var windView = WindView()
    lazy var uvSunset = UVSunsetView()
    lazy var humidityPressureView = HumidityPressureView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(averageFeelsView)
        stackView.addArrangedSubview(windView)
        stackView.addArrangedSubview(uvSunset)
        stackView.addArrangedSubview(humidityPressureView)
        
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: WeatherViewModel) {
        averageFeelsView.configure(with: viewModel)
        windView.configure(with: viewModel)
        uvSunset.configure(with: viewModel)
        humidityPressureView.configure(with: viewModel)
    }
}
