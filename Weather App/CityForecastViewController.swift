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
        setupSubviews()
        loadData()
    }
}

private extension CityForecastViewController {
    func setupSubviews() {
        //
    }

    func loadData() {
        webService.getWeatherToday(for: location) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let forecast):
                print(forecast)
            }
        }

        webService.getForecastFiveDay(for: location) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let forecasts):
                print(forecasts)
            }
        }
    }
}
