//
//  DailyForecastView.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 20.04.2026.
//

import UIKit
import SnapKit

final class DailyForecastView: UIView {
    private var items: [DayForecast] = []
    
    lazy var titleLabel: UILabel = {
        $0.appTextStyle(.sectionTitle)
        $0.text = "ПРОГНОЗ НА 5 ДНЕЙ"
        return $0
    }(UILabel())
    
    lazy var tableView: UITableView = {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.dataSource = self
        $0.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
        return $0
    }(UITableView())
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(white: 1, alpha: 0.15)
        layer.cornerRadius = 16
        
        addSubview(titleLabel)
        addSubview(tableView)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with items: [DayForecast]) {
        self.items = items
        tableView.reloadData()
    }
}


extension DailyForecastView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier, for: indexPath) as! DailyForecastCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
