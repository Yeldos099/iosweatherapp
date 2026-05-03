//
//  SearchViewController.swift
//  IOSWeatherApp
//
//  Created by Eldos Kolbay on 02.05.2026.
//

import UIKit
import MapKit
import SnapKit

protocol SearchViewControllerProtocol: AnyObject {
    func showResults(_ results: [MKLocalSearchCompletion])
    func showSavedCities(_ cities: [CityModel])
    func showError(_ message: String)
    func showEmpty()
}


final class SearchViewController: UIViewController {
    
    
    private enum Section: Int, CaseIterable {
        case savedCities
        case searchResults
    }
    
    private let presenter: SearchViewPresenterProtocol
    private var searchResults: [MKLocalSearchCompletion] = []
    private var savedCities: [CityModel] = []
    
    private lazy var searchTextfield = SearchTextField()
    
    
    private lazy var titleLabel: UILabel = {
        $0.textColor = .white
        $0.text = "Погода"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        return $0
    }(UILabel())
    
    
    private lazy var settingsButton: UIButton = {
        $0.setImage(.dots, for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 40
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        return $0
    }(UIButton())
    
    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(CityCell.self, forCellReuseIdentifier: CityCell.reuseIdentifier)
        return $0
    }(UITableView())
    
    private lazy var linkLabel: UILabel = {
        $0.text = "Подробнее о метеорологических и картографических данных"
        $0.numberOfLines = 0
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 14)
        $0.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
        $0.addGestureRecognizer(tap)
        return $0
    }(UILabel())
    init(presenter: SearchViewPresenterProtocol){
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .searchBg
        
        [titleLabel, settingsButton, tableView, linkLabel, searchTextfield].forEach {
            view.addSubview($0)
        }
        
        searchTextfield.onTextChanged = { [weak self] text in
            self?.presenter.search(query: text)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        settingsButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(linkLabel.snp.top).offset(-8)
        }
        
        linkLabel.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchTextfield.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(44)
        }
    }
    
    @objc private func linkTapped() {
        guard let url = URL(string: "https://openweathermap.org/weathermap") else { return }
        UIApplication.shared.open(url)
    }
}


extension SearchViewController: SearchViewControllerProtocol {
    func showError(_ message: String) {
        //
    }
    
    func showEmpty() {
        searchResults = []
        tableView.reloadData()
    }
    
    func showResults(_ results: [MKLocalSearchCompletion]) {
        self.searchResults = results
        tableView.reloadData()
    }
    
    func showSavedCities(_ cities: [CityModel]) {
        self.savedCities = cities
        tableView.reloadData()
    }
}


extension SearchViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reuseIdentifier, for: indexPath) as! CityCell
        switch Section(rawValue: indexPath.section) {
        case .savedCities: cell.configure(with: savedCities[indexPath.row])
        case .searchResults: cell.configureSearch(with: searchResults[indexPath.row])
        case .none: break
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .savedCities: return savedCities.count
        case .searchResults: return searchResults.count
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard Section(rawValue: indexPath.section) == .searchResults else { return }
        presenter.selectCity(searchResults[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard Section(rawValue: indexPath.section) == .savedCities else { return false }
        return !savedCities[indexPath.row].isCurrentLocation
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeCity(at: indexPath.row)
        }
    }
}
