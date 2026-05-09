//
//  PageIndicatorView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 09.05.2026.
//

import UIKit
import SnapKit

final class PageIndicatorView: UIView {
    
    private var dotViews: [UIView] = []
    private var currentIndex: Int = 0
    
    private lazy var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(count: Int, currentIndex: Int) {
        self.currentIndex = currentIndex
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews = []
        stackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
        
        for i in 0..<count {
            let dot = makeDot(index: i, isActive: i == currentIndex)
            dotViews.append(dot)
            stackView.addArrangedSubview(dot)
        }
    }
    
    func update(currentIndex: Int) {
        self.currentIndex = currentIndex
        for (i, dot) in dotViews.enumerated() {
            let isActive = i == currentIndex
            UIView.animate(withDuration: 0.2) {
                dot.alpha = isActive ? 1.0 : 0.5
                dot .transform = isActive ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
            }
            if i == 0 {
                if let imageView = dot.subviews.first as? UIImageView {
                    imageView.tintColor = isActive ? .white : .white.withAlphaComponent(0.5)
                }
            }
        }
    }
    
    private func makeDot(index: Int, isActive: Bool) -> UIView {
        if index == 0 {
            let container = UIView()
            let imageView = UIImageView(image: .cursor)
            imageView.tintColor = isActive ? .white : .white.withAlphaComponent(0.5)
            imageView.contentMode = .scaleAspectFit
            container.addSubview(imageView)
            imageView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.height.equalTo(20)
            }
            container.alpha = isActive ? 1.0 : 0.5
            return container
        } else {
            let dot = UIView()
            dot.backgroundColor = .white
            dot.layer.cornerRadius = 4
            dot.alpha = isActive ? 1.0 : 0.5
            dot.transform = isActive ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
            dot.snp.makeConstraints {
                $0.width.height.equalTo(8)
            }
            return dot
        }
    }
}
