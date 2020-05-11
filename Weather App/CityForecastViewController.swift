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

    private var forecasts: [Forecast] = []

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

        tableView.register(ForecastCell.self, forCellReuseIdentifier: "\(ForecastCell.self)")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets()
        tableView.dataSource = self

        [weatherDescriptionLabel, currentTempLabel, tableView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                weatherDescriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),

                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                weatherDescriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),

                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }

        NSLayoutConstraint.activate([
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            currentTempLabel.topAnchor.constraint(equalTo: weatherDescriptionLabel.bottomAnchor, constant: 10),
            currentTempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 10),
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
        var temp: [Forecast] = []
        let today = Date()
        var previous = Date()
        for forecast in forecasts {
            if Calendar.current.isDate(forecast.date, inSameDayAs: today) || Calendar.current.isDate(forecast.date, inSameDayAs: previous) {
                previous = forecast.date
                continue
            }
            temp.append(forecast)
            previous = forecast.date
        }
        self.forecasts = temp
        tableView.reloadData()
    }
}

extension CityForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ForecastCell.self)", for: indexPath) as? ForecastCell else {
            return UITableViewCell()
        }
        cell.configure(with: forecasts[indexPath.row])
        return cell
    }
}
