//
//  Webservice.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

class Webservice {
    private enum ForecastType {
        case today
        case fiveDay
    }

    func getWeatherToday(completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = buildQueryURL(type: .today) else { return }
        print(url.absoluteString)

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }

        }.resume()
    }

    func getForecastFiveDay(completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = buildQueryURL(type: .today) else { return }

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }

        }.resume()
    }

    private func buildQueryURL(type: ForecastType) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"

        switch type {
        case .today: components.path = "/data/2.5/weather"
        case .fiveDay: components.path = "/data/2.5/forecast"
        }

        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "q", value: "London"))
        components.queryItems?.append(URLQueryItem(name: "appid", value: "c6e381d8c7ff98f0fee43775817cf6ad"))
        components.queryItems?.append(URLQueryItem(name: "units", value: "metric"))

        return components.url
    }
}
