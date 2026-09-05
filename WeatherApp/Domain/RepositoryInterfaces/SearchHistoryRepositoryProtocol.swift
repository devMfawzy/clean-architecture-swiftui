//
//  SearchHistoryRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 21/03/2025.
//

import Foundation

protocol SearchHistoryRepositoryProtocol {
    func getRecentSearches() async throws -> [String]
    func addSearch(_ cityName: String) async throws
}
