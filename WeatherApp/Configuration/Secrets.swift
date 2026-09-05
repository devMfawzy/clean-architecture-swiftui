//
//  Secrets.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 05/09/2026.
//

import Foundation

/// Values read from `Secrets.plist`, which is kept out of version control.
///
/// Copy `Secrets.example.plist` to `Secrets.plist` and fill it in before
/// running the app. See the README for how to get a key.
enum Secrets {
    /// The value shipped in `Secrets.example.plist`, treated as "not set yet"
    /// so an unedited copy reports a missing key rather than a rejected one.
    private static let placeholder = "APIKeyHere"

    /// The OpenWeatherMap API key, or `nil` when `Secrets.plist` is missing,
    /// blank, or still holding the placeholder.
    static let weatherAPIKey: String? = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let values = NSDictionary(contentsOf: url) as? [String: Any]
        else {
            return nil
        }
        return apiKey(from: values)
    }()

    /// Reads the key out of a `Secrets.plist` dictionary, returning `nil` when it
    /// is absent, blank, or still the placeholder from `Secrets.example.plist`.
    static func apiKey(from values: [String: Any]) -> String? {
        guard let key = values["WeatherAPIKey"] as? String else {
            return nil
        }

        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty || trimmed == placeholder ? nil : trimmed
    }
}
