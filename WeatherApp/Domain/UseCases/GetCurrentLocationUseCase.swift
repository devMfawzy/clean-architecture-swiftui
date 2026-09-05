//
//  GetCurrentLocationUseCase.swift
//  WeatherApp
//
//  Created by Mohamed Fawzy on 21/03/2025.
//

import Foundation

class GetCurrentLocationUseCase {
    private let locationService: LocationServiceProtocol
    private var locationUpdateDelegate: LocationUpdateDelegate?
    
    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
        self.locationService.delegate = self
    }
    
    func startMonitoring(delegate: LocationUpdateDelegate) {
        self.locationUpdateDelegate = delegate
        locationService.startMonitoringLocation()
    }
    
    func stopMonitoring() {
        locationService.stopMonitoringLocation()
        self.locationUpdateDelegate = nil
    }
}

extension GetCurrentLocationUseCase: LocationServiceDelegate {
    func locationService(_ service: LocationServiceProtocol, didUpdateLocation location: Location) {
        locationUpdateDelegate?.didUpdateLocation(location)
    }
    
    func locationService(_ service: LocationServiceProtocol, didFailWithError error: Error) {
        locationUpdateDelegate?.didFailWithError(error)
    }
}

protocol LocationUpdateDelegate: AnyObject {
    func didUpdateLocation(_ location: Location)
    func didFailWithError(_ error: Error)
}
