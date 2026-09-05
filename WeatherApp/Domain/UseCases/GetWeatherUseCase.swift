//
//  GetWeatherUseCase.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

class GetWeatherUseCase {
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(forCity cityName: String, forceFresh: Bool = false) async throws -> Weather {
        if !forceFresh {
            // Try to get cached data first
            if let cachedWeather = try? await repository.getCachedWeather(forCity: cityName),
               // Only use cache if it's less than 30 minutes old
               cachedWeather.timestamp.timeIntervalSinceNow > -1800 {
                return cachedWeather
            }
        }
        
        // Get fresh data and cache it
        let weather = try await repository.getWeather(forCity: cityName)
        try? await repository.saveWeather(weather)
        return weather
    }
    
    func execute(latitude: Double, longitude: Double) async throws -> Weather {
        let weather = try await repository.getWeather(forLocation: latitude, longitude: longitude)
        try? await repository.saveWeather(weather)
        return weather
    }
}
