//
//  DetailBlockView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 24.04.2026.
//

import UIKit
import SnapKit

final class DetailBlockView: UIView {
    
    lazy var iconImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    lazy var titleLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        return $0
    }(UILabel())
    
    lazy var valueLabel: UILabel = {
        $0.appTextStyle(.detailValue)
        return $0
    }(UILabel())
    
    lazy var descriptionLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    
    lazy var subtitleLabel: UILabel = {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 12)
        $0.numberOfLines = 0
        $0.isHidden = true
        return $0
    }(UILabel())
    
    
    lazy var uvGradientView: UIView = {
        $0.isHidden = true
        $0.layer.cornerRadius = 2
        return $0
    }(UIView())
    
     init(icon: String, title: String){
        super.init(frame: .zero)
         setupUI()
         iconImageView.image = UIImage(named: icon)
         titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        GradientManager.applyGradient(to: self, colors: GradientManager.gradientColors(for: GradientManager.timeOfDay()))
        layer.cornerRadius = 16
        clipsToBounds = true
        if !uvGradientView.isHidden {
            GradientManager.applyGradient(to: uvGradientView,
                                          colors: [.green, .yellow, .orange, .red],
                                          startPoint: CGPoint(x: 0, y: 0.5),
                                          endPoint: CGPoint(x: 1, y: 0.5))
        }
    }
    
    private func setupUI() {
        [iconImageView, titleLabel, valueLabel, descriptionLabel, subtitleLabel, uvGradientView].forEach{
            addSubview($0)
            
        }
        
        uvGradientView.snp.makeConstraints {
            $0.top.equalTo(valueLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(uvGradientView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(value: String, description: String, subtitle: String?){
        valueLabel.text = value
        descriptionLabel.text = description
        
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        }
    }
    
    func showUVGradient() {
        uvGradientView.isHidden = false
        setNeedsLayout()
    }
}
