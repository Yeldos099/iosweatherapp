//
//  UVSunsetView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 24.04.2026.
//

import UIKit
import SnapKit

final class UVSunsetView: UIView {
    
    lazy var uvBlock = DetailBlockView(icon: "squeeze", title: "УФ-ИНДЕКС")
    lazy var sunsetBlock = DetailBlockView(icon: "sunset", title: "ЗАКАТ")
    
    
    lazy var stackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [uvBlock, sunsetBlock])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    override init(frame: CGRect){
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
        uvBlock.configure(value: "\(Int(viewModel.uvIndex))", description: uvDescription(for: viewModel.uvIndex), subtitle: nil)
        uvBlock.showUVGradient()
        sunsetBlock.configure(value: viewModel.sunsetTime, description: "Восход в \(viewModel.sunriseTime)", subtitle: nil)
    }
    
    private func uvDescription(for value: Double) -> String {
        switch value {
        case 0..<3: return "Низкий"
        case 3..<6: return "Умеренный"
        case 6..<8: return "Высокий"
        case 8..<11: return "Очень высокий"
        default: return "Экстремальный"
        }
    }
}
