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
        // Arrange — deliberately not key-shaped, so secret scanners don't flag it
        let values = ["WeatherAPIKey": "test-key-not-real"]

        // Act
        let key = Secrets.apiKey(from: values)

        // Assert
        XCTAssertEqual(key, "test-key-not-real")
    }

    func testTrimsWhitespacePastedAroundTheKey() {
        // Arrange
        let values = ["WeatherAPIKey": "  test-key-not-real\n"]

        // Act & Assert
        XCTAssertEqual(Secrets.apiKey(from: values), "test-key-not-real")
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
