//
//  LocationsService.swift
//  Weather App
//
//  Created by Sylvan Ash on 11/05/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

protocol LocationsProtocol {
    func getSavedLocations(completion: (Result<[String], Error>) -> Void)
    func save(location: String, completion: (Error?) -> Void)
}

extension UserDefaults: LocationsProtocol {
    func getSavedLocations(completion: (Result<[String], Error>) -> Void) {
        //
    }

    func save(location: String, completion: (Error?) -> Void) {
        //
    }
}
