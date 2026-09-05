//
//  WeatherResponseDTO.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

struct WeatherResponseDTO: Decodable {
    let id: Int
    let name: String
    let main: MainDTO
    let weather: [WeatherDescriptionDTO]
    let wind: WindDTO
    let dt: TimeInterval
    
    struct MainDTO: Decodable {
        let temp: Double
        let humidity: Int
    }
    
    struct WeatherDescriptionDTO: Decodable {
        let description: String
        let icon: String
    }
    
    struct WindDTO: Decodable {
        let speed: Double
    }
    
    func toDomain() -> Weather {
        return Weather(
            cityId: id,
            cityName: name,
            temperature: main.temp,
            description: weather.first?.description ?? "",
            humidity: main.humidity,
            windSpeed: wind.speed,
            iconCode: weather.first?.icon ?? "",
            timestamp: Date(timeIntervalSince1970: dt)
        )
    }
}
