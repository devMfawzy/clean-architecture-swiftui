//
//  WeatherRemoteDataSource.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

class WeatherRemoteDataSource {
    private let apiKey = "API_KEY"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeather(forCity cityName: String) async throws -> WeatherResponseDTO {
        guard let url = URL(string: "\(baseURL)?q=\(cityName)&units=metric&appid=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(WeatherResponseDTO.self, from: data)
    }
    
    func getWeather(forLocation latitude: Double, longitude: Double) async throws -> WeatherResponseDTO {
        guard let url = URL(string: "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(WeatherResponseDTO.self, from: data)
    }
}

enum APIError: Error {
    case invalidResponse
    case decodingError
}
