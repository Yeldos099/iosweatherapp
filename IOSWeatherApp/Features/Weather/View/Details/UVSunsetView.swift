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
        uvBlock.configure(value: "0", description: "Низкий", subtitle: nil)
        sunsetBlock.configure(value: "17:29", description: "Восход в 06:23", subtitle: nil)
    }
}
