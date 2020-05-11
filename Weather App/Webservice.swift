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

    func getWeatherToday(for location: String, completion: @escaping (Result<Forecast, Error>) -> Void) {
        guard let url = buildQueryURL(type: .today, for: location) else { return }

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }
            guard let data = dataOrNil else { return }

            do {
                let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                completion(.success(forecast))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    func getForecastFiveDay(for location: String, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        guard let url = buildQueryURL(type: .fiveDay, for: location) else { return }
        print(url.absoluteString)

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }
            guard let data = dataOrNil else { return }

            do {
                let forecasts = try JSONDecoder().decode(ForecastArray.self, from: data)
                completion(.success(forecasts.list))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    private func buildQueryURL(type: ForecastType, for location: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"

        switch type {
        case .today: components.path = "/data/2.5/weather"
        case .fiveDay: components.path = "/data/2.5/forecast"
        }

        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "q", value: location))
        components.queryItems?.append(URLQueryItem(name: "appid", value: "c6e381d8c7ff98f0fee43775817cf6ad"))
        components.queryItems?.append(URLQueryItem(name: "units", value: "metric"))

        return components.url
    }
}
