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
    /// The OpenWeatherMap API key, or `nil` when `Secrets.plist` is missing or blank.
    static let weatherAPIKey: String? = {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let values = NSDictionary(contentsOf: url) as? [String: Any],
              let key = values["WeatherAPIKey"] as? String,
              !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }
        return key
    }()
}
