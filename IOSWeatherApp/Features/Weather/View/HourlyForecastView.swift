//
//  HourlyForecastView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import UIKit
import SnapKit

final class HourlyForecastView: UIView {
    
    private var items: [HourForecast] = []
    
    lazy var windLabel: UILabel = {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .textPrimary
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    lazy var separator: UIView = {
        $0.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
        return $0
    }(UIView())
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 80)
        layout.minimumLineSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.identifier)
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        layer.cornerRadius = 16
        
        addSubview(windLabel)
        addSubview(separator)
        addSubview(collectionView)
        
        windLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(windLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(0.5)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(separator.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview().inset(8)
            $0.height.equalTo(80)
        }
    }
    
    func configure(with items: [HourForecast]) {
        self.items = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func configureWind(with text: String) {
        windLabel.text = text
    }
}


extension HourlyForecastView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCell.identifier, for: indexPath) as! HourlyForecastCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
}
