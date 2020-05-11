//
//  CityForecastViewController.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class CityForecastViewController: UIViewController {
    private let location: String
    private let webService: Webservice

    private let weatherDescriptionLabel = UILabel()
    private let currentTempLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)

    init(location: String, webService: Webservice = Webservice()) {
        self.location = location
        self.webService = webService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        loadData()
    }
}

private extension CityForecastViewController {
    func setupSubviews() {
        navigationItem.title = location

        currentTempLabel.font = UIFont.boldSystemFont(ofSize: 72)

        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.dataSource = self

        [weatherDescriptionLabel, currentTempLabel, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                weatherDescriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            ])
        } else {
            NSLayoutConstraint.activate([
                weatherDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            ])
        }

        NSLayoutConstraint.activate([
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            currentTempLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 10),
            currentTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        weatherDescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    func loadData() {
        webService.getWeatherToday(for: location) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let forecast):
                print(forecast)
                DispatchQueue.main.async {
                    self.updateMainWeather(forecast)
                }
            }
        }

        webService.getForecastFiveDay(for: location) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let forecasts):
                print(forecasts)
                DispatchQueue.main.async {
                    self.updateDailyWeather(forecasts)
                }
            }
        }
    }

    func updateMainWeather(_ forecast: Forecast) {
        if let weather = forecast.weather.first {
            weatherDescriptionLabel.text = weather.description
        }
        let temp = Int(forecast.main.temp.rounded())
        currentTempLabel.text = "\(temp)°"
    }

    func updateDailyWeather(_ forecasts: [Forecast]) {

    }
}

extension CityForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
