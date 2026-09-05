//
//  MockGetWeatherUseCase.swift
//  WeatherAppTests
//
//  Created by Mohamed Fawzy on 24/03/2025.
//

import Foundation
@testable import WeatherApp

class MockGetWeatherUseCase: GetWeatherUseCaseProtocol {
    var mockWeather: Weather?
    var shouldThrowError = false
    var errorToThrow: Error = NSError(domain: "test", code: 0)

    var executeForCityCalled = false
    var executeForLocationCalled = false
    var lastForceFresh = false

    func execute(forCity cityName: String, forceFresh: Bool = false) async throws -> Weather {
        executeForCityCalled = true
        lastForceFresh = forceFresh

        if shouldThrowError {
            throw errorToThrow
        }

        guard let weather = mockWeather else {
            throw NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock weather"])
        }

        return weather
    }

    func execute(latitude: Double, longitude: Double) async throws -> Weather {
        executeForLocationCalled = true

        if shouldThrowError {
            throw errorToThrow
        }

        guard let weather = mockWeather else {
            throw NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "No mock weather"])
        }

        return weather
    }
}
