//
//  MockGetCurrentLocationUseCase.swift
//  WeatherAppTests
//
//  Created by Mohamed Fawzy on 24/03/2025.
//

import Foundation
@testable import WeatherApp

class MockGetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {
    var mockLocation: Location?
    var shouldThrowError = false
    var errorToThrow: Error = NSError(domain: "test", code: 0)

    var startMonitoringCalled = false
    var stopMonitoringCalled = false
    var lastDelegate: LocationUpdateDelegate?

    func startMonitoring(delegate: LocationUpdateDelegate) {
        startMonitoringCalled = true
        lastDelegate = delegate

        if let location = mockLocation {
            delegate.didUpdateLocation(location)
        }
    }

    func stopMonitoring() {
        stopMonitoringCalled = true
        lastDelegate = nil
    }
}
