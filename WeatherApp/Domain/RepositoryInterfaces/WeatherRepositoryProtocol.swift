//
//  WeatherRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func getWeather(forCity cityName: String) async throws -> Weather
    func getWeather(forLocation latitude: Double, longitude: Double) async throws -> Weather
    func getCachedWeather(forCity cityName: String) async throws -> Weather?
    func saveWeather(_ weather: Weather) async throws
}
