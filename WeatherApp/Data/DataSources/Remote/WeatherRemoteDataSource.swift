//
//  WeatherRemoteDataSource.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

class WeatherRemoteDataSource {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    /// Fetches current weather for a city by name.
    func getWeather(forCity cityName: String) async throws -> WeatherResponseDTO {
        try await fetch(query: [URLQueryItem(name: "q", value: cityName)])
    }

    /// Fetches current weather for a pair of coordinates.
    func getWeather(forLocation latitude: Double, longitude: Double) async throws -> WeatherResponseDTO {
        try await fetch(query: [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude))
        ])
    }

    private func fetch(query: [URLQueryItem]) async throws -> WeatherResponseDTO {
        guard let apiKey = Secrets.weatherAPIKey else {
            throw APIError.missingAPIKey
        }

        guard var components = URLComponents(string: baseURL) else {
            throw URLError(.badURL)
        }
        components.queryItems = query + [
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw httpResponse.statusCode == 401 ? APIError.unauthorized : APIError.invalidResponse
        }

        return try JSONDecoder().decode(WeatherResponseDTO.self, from: data)
    }
}

enum APIError: Error {
    case invalidResponse
    case decodingError
    case missingAPIKey
    case unauthorized
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The weather service returned an unexpected response."
        case .decodingError:
            return "The weather data could not be read."
        case .missingAPIKey:
            return "No API key found. Copy Secrets.example.plist to Secrets.plist and add your OpenWeatherMap key — see the README."
        case .unauthorized:
            return "The API key was rejected. Check the key in Secrets.plist. New keys can take a couple of hours to activate."
        }
    }
}
