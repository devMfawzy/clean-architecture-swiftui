//
//  WeatherLocal.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

struct WeatherLocal: Codable {
    let cityId: Int
    let cityName: String
    let temperature: Double
    let description: String
    let humidity: Int
    let windSpeed: Double
    let iconCode: String
    let timestamp: Date
    
    func toDomain() -> Weather {
        return Weather(
            cityId: cityId,
            cityName: cityName,
            temperature: temperature,
            description: description,
            humidity: humidity,
            windSpeed: windSpeed,
            iconCode: iconCode,
            timestamp: timestamp
        )
    }
    
    static func fromDomain(_ domain: Weather) -> WeatherLocal {
        return WeatherLocal(
            cityId: domain.cityId,
            cityName: domain.cityName,
            temperature: domain.temperature,
            description: domain.description,
            humidity: domain.humidity,
            windSpeed: domain.windSpeed,
            iconCode: domain.iconCode,
            timestamp: domain.timestamp
        )
    }
}
