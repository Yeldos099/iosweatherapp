//
//  AverageFeelsView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 24.04.2026.
//

import UIKit
import SnapKit

final class AverageFeelsView: UIView {
    
    lazy var averageBlock = DetailBlockView(icon: "graph", title: "В СРЕДНЕМ")
    lazy var feelsLikeBlock = DetailBlockView(icon: "thermometer", title: "ОЩУЩАЕТСЯ КАК")
    
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [averageBlock, feelsLikeBlock])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
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
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: WeatherViewModel){
        averageBlock.configure(value: viewModel.tempMax, description: "> среднесуточного максимума\nМакс.: \(viewModel.tempMax) Мин.: \(viewModel.tempMin)", subtitle: nil )
        feelsLikeBlock.configure(value: viewModel.feelsLike, description: viewModel.feelsLikeDescription, subtitle: nil)
    }
}
