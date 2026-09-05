//
//  SearchHistoryRepository.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 21/03/2025.
//

import Foundation

class SearchHistoryRepository: SearchHistoryRepositoryProtocol {
    private let localDataSource: SearchHistoryLocalDataSourceProtocol
    
    init(localDataSource: SearchHistoryLocalDataSourceProtocol) {
        self.localDataSource = localDataSource
    }
    
    func getRecentSearches() async throws -> [String] {
        return try localDataSource.getRecentSearches()
    }
    
    func addSearch(_ cityName: String) async throws {
        try localDataSource.saveSearch(cityName)
    }
}
