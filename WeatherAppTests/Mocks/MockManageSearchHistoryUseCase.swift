//
//  MockManageSearchHistoryUseCase.swift
//  WeatherAppTests
//
//  Created by Mohamed Fawzy on 24/03/2025.
//

import Foundation
@testable import WeatherApp

class MockManageSearchHistoryUseCase: ManageSearchHistoryUseCaseProtocol {
    var mockSearches: [String] = []
    var shouldThrowError = false

    var getRecentSearchesCalled = false
    var addSearchTermCalled = false
    var lastSearchTerm: String?

    func getRecentSearches() async throws -> [String] {
        getRecentSearchesCalled = true

        if shouldThrowError {
            throw NSError(domain: "test", code: 0)
        }

        return mockSearches
    }

    func addSearchTerm(_ cityName: String) async throws {
        addSearchTermCalled = true
        lastSearchTerm = cityName

        if shouldThrowError {
            throw NSError(domain: "test", code: 0)
        }

        // Add to mock searches if not already there
        if !mockSearches.contains(cityName) {
            mockSearches.insert(cityName, at: 0)
            if mockSearches.count > 5 {
                mockSearches = Array(mockSearches.prefix(5))
            }
        }
    }
}
