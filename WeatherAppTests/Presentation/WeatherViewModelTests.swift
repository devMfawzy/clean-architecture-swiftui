//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Mohamed Fawzy on 05/09/2026.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    var mockGetWeather: MockGetWeatherUseCase!
    var mockGetLocation: MockGetCurrentLocationUseCase!
    var mockSearchHistory: MockManageSearchHistoryUseCase!

    override func setUp() {
        super.setUp()
        mockGetWeather = MockGetWeatherUseCase()
        mockGetLocation = MockGetCurrentLocationUseCase()
        mockSearchHistory = MockManageSearchHistoryUseCase()
    }

    override func tearDown() {
        mockGetWeather = nil
        mockGetLocation = nil
        mockSearchHistory = nil
        super.tearDown()
    }

    func testFetchWeatherPublishesUIModel() {
        // Arrange
        mockGetWeather.mockWeather = makeWeather(cityName: "Cairo", temperature: 31.4)
        let viewModel = makeViewModel()

        // Act
        viewModel.fetchWeather(forCity: "Cairo")

        // Assert
        waitUntil { viewModel.weatherUIModel != nil }
        XCTAssertEqual(viewModel.weatherUIModel?.cityName, "Cairo")
        XCTAssertEqual(viewModel.weatherUIModel?.temperature, "31°C")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchWeatherIgnoresAnEmptyCityName() {
        // Arrange
        let viewModel = makeViewModel()

        // Act
        viewModel.fetchWeather(forCity: "")

        // Assert
        XCTAssertFalse(mockGetWeather.executeForCityCalled)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testFetchWeatherRecordsTheCityInRecentSearches() {
        // Arrange
        mockGetWeather.mockWeather = makeWeather(cityName: "Dubai")
        let viewModel = makeViewModel()

        // Act
        viewModel.fetchWeather(forCity: "Dubai")

        // Assert
        waitUntil { self.mockSearchHistory.addSearchTermCalled }
        XCTAssertEqual(mockSearchHistory.lastSearchTerm, "Dubai")
    }

    func testFailedFetchPublishesAnErrorAndStopsLoading() {
        // Arrange
        mockGetWeather.shouldThrowError = true
        let viewModel = makeViewModel()

        // Act
        viewModel.fetchWeather(forCity: "Cairo")

        // Assert
        waitUntil { viewModel.errorMessage != nil }
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.weatherUIModel)
    }

    func testFailedFetchDoesNotRecordTheCity() {
        // Arrange
        mockGetWeather.shouldThrowError = true
        let viewModel = makeViewModel()

        // Act
        viewModel.fetchWeather(forCity: "Nowhere")

        // Assert
        waitUntil { viewModel.errorMessage != nil }
        XCTAssertFalse(mockSearchHistory.addSearchTermCalled)
    }

    func testRefreshAsksForFreshDataForTheCurrentCity() {
        // Arrange
        mockGetWeather.mockWeather = makeWeather(cityName: "Riyadh")
        let viewModel = makeViewModel()
        viewModel.fetchWeather(forCity: "Riyadh")
        waitUntil { viewModel.weatherUIModel != nil }

        // Act
        viewModel.refreshWeather()

        // Assert
        waitUntil { self.mockGetWeather.lastForceFresh }
        XCTAssertTrue(mockGetWeather.lastForceFresh)
    }

    func testRefreshFallsBackToLocationWhenNoCityIsShown() {
        // Arrange
        let viewModel = makeViewModel()

        // Act
        viewModel.refreshWeather()

        // Assert
        XCTAssertTrue(mockGetLocation.startMonitoringCalled)
        XCTAssertFalse(mockGetWeather.executeForCityCalled)
    }

    func testALocationUpdateFetchesWeatherForThoseCoordinates() {
        // Arrange
        mockGetWeather.mockWeather = makeWeather(cityName: "Alexandria")
        mockGetLocation.mockLocation = Location(latitude: 31.2, longitude: 29.9)
        let viewModel = makeViewModel()

        // Act
        viewModel.fetchWeatherForCurrentLocation()

        // Assert
        waitUntil { viewModel.weatherUIModel != nil }
        XCTAssertTrue(mockGetWeather.executeForLocationCalled)
        XCTAssertEqual(viewModel.weatherUIModel?.cityName, "Alexandria")
    }

    func testDeniedPermissionShowsTheInfoViewRatherThanAnError() {
        // Arrange
        let viewModel = makeViewModel()

        // Act
        viewModel.didFailWithError(LocationError.permissionDenied)

        // Assert
        waitUntil { viewModel.showLocationPermissionInfo }
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testOtherLocationFailuresPublishAnError() {
        // Arrange
        let viewModel = makeViewModel()

        // Act
        viewModel.didFailWithError(LocationError.locationNotFound)

        // Assert
        waitUntil { viewModel.errorMessage != nil }
        XCTAssertFalse(viewModel.showLocationPermissionInfo)
    }

    // MARK: - Helpers

    private func makeViewModel() -> WeatherViewModel {
        WeatherViewModel(
            getWeatherUseCase: mockGetWeather,
            getLocationUseCase: mockGetLocation,
            searchHistoryUseCase: mockSearchHistory
        )
    }

    private func makeWeather(cityName: String, temperature: Double = 20) -> Weather {
        Weather(
            cityId: 1,
            cityName: cityName,
            temperature: temperature,
            description: "clear sky",
            humidity: 40,
            windSpeed: 3.5,
            iconCode: "01d",
            timestamp: Date()
        )
    }

    /// Runs the main run loop until `condition` holds, so work started on a
    /// detached `Task` has a chance to land on the published properties.
    private func waitUntil(
        timeout: TimeInterval = 2,
        file: StaticString = #filePath,
        line: UInt = #line,
        _ condition: () -> Bool
    ) {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition() && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.01))
        }
        XCTAssertTrue(condition(), "Condition was not met within \(timeout)s", file: file, line: line)
    }
}
