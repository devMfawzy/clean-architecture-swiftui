//
//  SecretsTests.swift
//  WeatherAppTests
//
//  Created by Mohamed Fawzy on 05/09/2026.
//

import XCTest
@testable import WeatherApp

class SecretsTests: XCTestCase {
    func testReturnsTheKeyWhenOneIsSet() {
        // Arrange
        let values = ["WeatherAPIKey": "0123456789abcdef0123456789abcdef"]

        // Act
        let key = Secrets.apiKey(from: values)

        // Assert
        XCTAssertEqual(key, "0123456789abcdef0123456789abcdef")
    }

    func testTrimsWhitespacePastedAroundTheKey() {
        // Arrange
        let values = ["WeatherAPIKey": "  abc123\n"]

        // Act & Assert
        XCTAssertEqual(Secrets.apiKey(from: values), "abc123")
    }

    func testTreatsTheExamplePlaceholderAsUnset() {
        // Arrange
        let values = ["WeatherAPIKey": "APIKeyHere"]

        // Act & Assert
        XCTAssertNil(Secrets.apiKey(from: values))
    }

    func testTreatsABlankValueAsUnset() {
        XCTAssertNil(Secrets.apiKey(from: ["WeatherAPIKey": ""]))
        XCTAssertNil(Secrets.apiKey(from: ["WeatherAPIKey": "   "]))
    }

    func testTreatsAMissingEntryAsUnset() {
        XCTAssertNil(Secrets.apiKey(from: [:]))
        XCTAssertNil(Secrets.apiKey(from: ["SomeOtherKey": "value"]))
    }

    func testTheCommittedExampleFileHoldsNoRealKey() throws {
        // Arrange — Secrets.example.plist is tracked, so this guards against a
        // real key ever being committed into it.
        let repositoryRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()    // Configuration
            .deletingLastPathComponent()    // WeatherAppTests
            .deletingLastPathComponent()    // repository root
        let url = repositoryRoot.appendingPathComponent("Secrets.example.plist")
        let values = try XCTUnwrap(NSDictionary(contentsOf: url) as? [String: Any])

        // Act & Assert
        XCTAssertNil(Secrets.apiKey(from: values), "Secrets.example.plist must not contain a real key")
    }
}
