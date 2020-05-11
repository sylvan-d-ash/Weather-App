//
//  Forecast.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

struct ForecastArray: Decodable {
    let list: [Forecast]
}

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
    let date: Date

    private enum CodingKeys: String, CodingKey {
        case main, weather, wind
        case date = "dt"
    }
}

extension Forecast {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        main = try container.decode(Main.self, forKey: .main)
        weather = try container.decode([Weather].self, forKey: .weather)
        wind = try container.decode(Wind.self, forKey: .wind)

        let datetime = try container.decode(Int.self, forKey: .date)
        date = Date(timeIntervalSince1970: TimeInterval(datetime))
    }
}
