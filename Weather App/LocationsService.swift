//
//  LocationsService.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

enum LocationsError: Error {
    case locationNotFound
}

protocol LocationsProtocol: class {
    func getSavedLocations(completion: (Result<[String], Error>) -> Void)
    func save(location: String, completion: (Error?) -> Void)
    func delete(location: String, completion: (Result<[String], Error>) -> Void)
}

class LocationsService: LocationsProtocol {
    private enum Keys {
        static let locations = "Locations"
    }
    private let defaults = UserDefaults.standard

    func getSavedLocations(completion: (Result<[String], Error>) -> Void) {
        let locations = defaults.object(forKey: Keys.locations) as? [String]
        completion(.success(locations ?? []))
    }

    func save(location: String, completion: (Error?) -> Void) {
        var locations = defaults.object(forKey: Keys.locations) as? [String] ?? []
        locations.append(location)
        defaults.set(locations, forKey: Keys.locations)
        completion(nil)
    }

    func delete(location: String, completion: (Result<[String], Error>) -> Void) {
        var locations = defaults.object(forKey: Keys.locations) as? [String] ?? []
        guard let index = locations.firstIndex(of: location) else {
            completion(.failure(LocationsError.locationNotFound))
            return
        }
        locations.remove(at: index)
        defaults.set(locations, forKey: Keys.locations)
        completion(.success(locations))
    }
}
