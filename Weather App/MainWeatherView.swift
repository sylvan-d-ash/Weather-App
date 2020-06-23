//
//  MainWeatherView.swift
//  Weather App
//
//  Created by Sylvan Ash on 23/06/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class MainWeatherView: UIView {
    private let locationLabel = UILabel()
    private let iconLabel = UILabel()
    private let temperatureLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    func update(with forecast: Forecast, and location: String) {
        locationLabel.text = location

        let temperature = Int(forecast.main.temp.rounded())
        temperatureLabel.text = "\(temperature)°"

//        if let weather = forecast.weather.first {
//            weatherDescriptionLabel.text = weather.description
//        }
    }
}

private extension MainWeatherView {
    func setupSubviews() {
        //
    }
}
