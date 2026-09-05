//
//  ManageSearchHistoryUseCase.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 21/03/2025.
//

import Foundation

class ManageSearchHistoryUseCase {
    private let repository: SearchHistoryRepositoryProtocol
    
    init(repository: SearchHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func getRecentSearches() async throws -> [String] {
        return try await repository.getRecentSearches()
    }
    
    func addSearchTerm(_ cityName: String) async throws {
        try await repository.addSearch(cityName)
    }
}
