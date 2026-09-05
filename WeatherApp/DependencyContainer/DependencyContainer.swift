//
//  DependencyContainer.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 18/03/2025.
//

import Foundation

class DependencyContainer {
    // Data Sources
    lazy var weatherRemoteDataSource = WeatherRemoteDataSource()
    lazy var weatherLocalDataSource = WeatherLocalDataSource()
    lazy var searchHistoryLocalDataSource = SearchHistoryLocalDataSource()
    
    // Services
    lazy var locationService = LocationService()

    // Repositories
    lazy var weatherRepository: WeatherRepositoryProtocol = WeatherRepository(
        remoteDataSource: weatherRemoteDataSource,
        localDataSource: weatherLocalDataSource
    )
    lazy var searchHistoryRepository: SearchHistoryRepositoryProtocol = SearchHistoryRepository(
        localDataSource: searchHistoryLocalDataSource
    )
    
    
    // Use Cases
    lazy var getWeatherUseCase: GetWeatherUseCaseProtocol = GetWeatherUseCase(
        repository: weatherRepository
    )
    lazy var manageSearchHistoryUseCase: ManageSearchHistoryUseCaseProtocol = ManageSearchHistoryUseCase(
        repository: searchHistoryRepository
    )
    lazy var getCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol = GetCurrentLocationUseCase(
        locationService: locationService
    )
    
    
    // ViewModels
    func makeWeatherViewModel() -> WeatherViewModel {
        return WeatherViewModel(
            getWeatherUseCase: getWeatherUseCase,
            getLocationUseCase: getCurrentLocationUseCase,
            searchHistoryUseCase: manageSearchHistoryUseCase
        )
    }
}
