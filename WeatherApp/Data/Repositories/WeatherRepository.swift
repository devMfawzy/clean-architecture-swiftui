//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

class WeatherRepository: WeatherRepositoryProtocol {
    private let remoteDataSource: WeatherRemoteDataSource
    private let localDataSource: WeatherLocalDataSource
    
    init(remoteDataSource: WeatherRemoteDataSource, localDataSource: WeatherLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getWeather(forCity cityName: String) async throws -> Weather {
        let weatherDTO = try await remoteDataSource.getWeather(forCity: cityName)
        return weatherDTO.toDomain()
    }
    
    func getWeather(forLocation latitude: Double, longitude: Double) async throws -> Weather {
        let weatherDTO = try await remoteDataSource.getWeather(forLocation: latitude, longitude: longitude)
        return weatherDTO.toDomain()
    }
    
    func getCachedWeather(forCity cityName: String) async throws -> Weather? {
        return try localDataSource.getWeather(forCity: cityName)?.toDomain()
    }
    
    func saveWeather(_ weather: Weather) async throws {
        let localModel = WeatherLocal.fromDomain(weather)
        try localDataSource.saveWeather(localModel)
    }
}
