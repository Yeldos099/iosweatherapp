//
//  TemperatureRangeView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import UIKit

final class TemperatureRangeView: UIView {
    
    let coldColor = UIColor(.coldTemp)
    let warmColor = UIColor(.warmTemp)
    
    private var minTemp: Double = 0
    private var maxTemp: Double = 0
    private var globalMin: Double = 0
    private var globalMax: Double = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure(minTemp: minTemp, maxTemp: maxTemp, globalMin: globalMin, globalMax: globalMax)
    }
    
    func configure(minTemp: Double, maxTemp: Double, globalMin: Double, globalMax: Double){
        
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.globalMin = globalMin
        self.globalMax = globalMax
        
        layer.sublayers?.removeAll()
        
        let range = globalMax - globalMin
        guard range > 0 else { return }
        
        let totalWidth = bounds.width
        let height = bounds.height
        
        let startX = CGFloat((minTemp - globalMin) / range) * totalWidth
        let endX = CGFloat((maxTemp - globalMin) / range) * totalWidth
        
        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: totalWidth, height: height)
        bgLayer.backgroundColor = UIColor(white: 1.0, alpha: 0.2).cgColor
        bgLayer.cornerRadius = height / 2
        layer.addSublayer(bgLayer)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: startX, y: 0, width: endX - startX, height: height)
        gradientLayer.cornerRadius = height / 2
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let startColor = interpolateColor(at: CGFloat((minTemp - globalMin) / range))
        let endColor = interpolateColor(at: CGFloat((maxTemp - globalMin) / range))
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        
        layer.addSublayer(gradientLayer)
    }
    
    private func interpolateColor(at position: CGFloat) -> UIColor {
        let r = coldColor.rgba.r + (warmColor.rgba.r - coldColor.rgba.r) * position
        let g = coldColor.rgba.g + (warmColor.rgba.g - coldColor.rgba.g) * position
        let b = coldColor.rgba.b + (warmColor.rgba.b - coldColor.rgba.b) * position
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}


extension UIColor {
    var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}
