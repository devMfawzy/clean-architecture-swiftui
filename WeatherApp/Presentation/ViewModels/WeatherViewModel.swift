//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

class WeatherViewModel: ObservableObject {
    private let getWeatherUseCase: GetWeatherUseCaseProtocol
    private let searchHistoryUseCase: ManageSearchHistoryUseCaseProtocol
    private let getLocationUseCase: GetCurrentLocationUseCaseProtocol
    
    @Published var weatherUIModel: WeatherUIModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var recentSearches: [String] = []
    @Published var showLocationPermissionInfo = false
    
    init(
        getWeatherUseCase: GetWeatherUseCaseProtocol,
        getLocationUseCase: GetCurrentLocationUseCaseProtocol,
        searchHistoryUseCase: ManageSearchHistoryUseCaseProtocol
    ) {
        self.getWeatherUseCase = getWeatherUseCase
        self.getLocationUseCase = getLocationUseCase
        self.searchHistoryUseCase = searchHistoryUseCase
        
        Task {
            await loadRecentSearches()
        }
    }
    
    func fetchWeather(forCity cityName: String, forceFresh: Bool = false) {
        guard !cityName.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let weather = try await getWeatherUseCase.execute(forCity: cityName, forceFresh: forceFresh)
                await updateUI(with: weather)
                await addToRecentSearches(cityName)
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchWeatherFor(location: Location) async {
        do {
            let weather = try await getWeatherUseCase.execute(
                latitude: location.latitude,
                longitude: location.longitude
            )
            await updateUI(with: weather)
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func fetchWeatherForCurrentLocation() {
        isLoading = true
        errorMessage = nil
        getLocationUseCase.startMonitoring(delegate: self)
    }
    
    func refreshWeather() {
        if let currentCity = weatherUIModel?.cityName {
            fetchWeather(forCity: currentCity, forceFresh: true)
        } else {
            fetchWeatherForCurrentLocation()
        }
    }
        
    // MARK: - Private Helper Methods
    
    @MainActor
    private func updateUI(with weather: Weather) {
        self.weatherUIModel = WeatherUIModel.fromDomain(weather)
        self.isLoading = false
    }
    
    @MainActor
    private func loadRecentSearches() async {
        do {
            self.recentSearches = try await searchHistoryUseCase.getRecentSearches()
        } catch {
            print("Failed to load recent searches: \(error)")
        }
    }
    
    @MainActor
    private func addToRecentSearches(_ cityName: String) async {
        do {
            try await searchHistoryUseCase.addSearchTerm(cityName)
            // Reload the list
            self.recentSearches = try await searchHistoryUseCase.getRecentSearches()
        } catch {
            print("Failed to update recent searches: \(error)")
        }
    }
}

extension WeatherViewModel: LocationUpdateDelegate {
    func didUpdateLocation(_ location: Location) {
        Task {
            await fetchWeatherFor(location: location)
        }
    }
    
    func didFailWithError(_ error: Error) {
        Task {
            await MainActor.run {
                // Only show errors that aren't related to permissions
                if let locationError = error as? LocationError, case .permissionDenied = locationError {
                    // For permission errors in continuous updates, show settings info instead of error
                    self.showLocationPermissionInfo = true
                } else {
                    self.errorMessage = "Location error: \(error.localizedDescription)"
                }
                self.isLoading = false
            }
        }
    }
}

