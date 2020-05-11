//
//  Forecast.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    struct Main: Decodable {
        let temp: Double
        let minTemp: Double
        let maxTemp: Double
        let pressure: Double
        let humidity: Double

        private enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
        }
    }

    struct Wind: Decodable {
        let speed: Double
        var gust: Double?
        var deg: Double?
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    let main: Main
    let weather: [Weather]
    let wind: Wind
}
