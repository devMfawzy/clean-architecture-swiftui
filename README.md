# WeatherApp

A SwiftUI weather app built to show Clean Architecture working end to end: strict
layer separation, protocol-driven dependency injection, and unit tests across the
domain, data and presentation layers.

[![Clean Architecture in SwiftUI](https://img.shields.io/badge/Medium-Clean%20Architecture%20in%20SwiftUI-000000?logo=medium&logoColor=white)](https://medium.com/@mo.fawzy/clean-architecture-in-swiftui-4eb33a187cdc)
![Swift 5](https://img.shields.io/badge/Swift-5-F05138?logo=swift&logoColor=white)
![iOS 18.2+](https://img.shields.io/badge/iOS-18.2%2B-black?logo=apple&logoColor=white)

I wrote it alongside **[Clean Architecture in SwiftUI](https://medium.com/@mo.fawzy/clean-architecture-in-swiftui-4eb33a187cdc)**,
which walks through the reasoning behind each layer and why the dependencies point
the way they do.

## Core Principles of Clean Architecture

### Separation of Layers

1. **Domain Layer**: This layer contains the business logic, entities, and use cases of the application.
2. **Data Layer**: This layer includes repositories and data sources.
3. **Presentation Layer**: This layer is responsible for the UI components and ViewModels.

### Dependency Rule

- Dependencies only point inward. Outer layers depend on inner layers, but not vice versa.

## Project Structure
```
WeatherApp/
├── Domain/
│   ├── Entities/
│   │   ├── Location.swift
│   │   └── Weather.swift
│   ├── RepositoryInterfaces/
│   │   ├── WeatherRepositoryProtocol.swift
│   │   └── SearchHistoryRepositoryProtocol.swift
│   ├── Services/
│   │   └── LocationServiceProtocol.swift
│   └── UseCases/
│       ├── GetWeatherUseCase.swift
│       ├── GetCurrentLocationUseCase.swift
│       └── ManageSearchHistoryUseCase.swift
├── Data/
│   ├── RepositoryImplementation/
│   │   ├── WeatherRepository.swift
│   │   └── SearchHistoryRepository.swift
│   ├── DataSources/
│   │   ├── Remote/
│   │   │   └── WeatherRemoteDataSource.swift
│   │   └── Local/
│   │       ├── SearchHistoryLocalDataSource.swift
│   │       └── WeatherLocalDataSource.swift
│   ├── Services/
│   │   └── LocationService.swift
│   └── DataModels/
│       ├── WeatherResponseDTO.swift
│       └── WeatherLocal.swift
├── Presentation/
│   ├── Views/
│   │   ├── WeatherView.swift
│   │   ├── WeatherContentView.swift
│   │   ├── SearchView.swift
│   │   └── Components/
│   │       ├── WeatherCardView.swift
│   │       ├── ErrorView.swift
│   │       ├── LocationPermissionInfoView.swift
│   │       └── LoadingView.swift
│   ├── ViewModels/
│   │   └── WeatherViewModel.swift
│   └── UIModels/
│       └── WeatherUIModel.swift
├── Configuration/
│   └── Secrets.swift
└── DependencyContainer/
    └── DependencyContainer.swift
```

The `Domain` layer imports nothing but `Foundation`. `Data` implements the
protocols it declares, and `Presentation` depends on use cases rather than
repositories, so each layer can be tested against mocks of the layer beneath it.

## Getting Started

### 1. Clone and open

```sh
git clone https://github.com/devMfawzy/WeatherApp.git
cd WeatherApp
open WeatherApp.xcodeproj
```

### 2. Add an API key

Weather data comes from [OpenWeatherMap](https://openweathermap.org/api), which
needs a free API key. Sign up, copy your key from the API keys tab, then:

```sh
cp Secrets.example.plist WeatherApp/Secrets.plist
```

Open `WeatherApp/Secrets.plist` and paste the key into `WeatherAPIKey`.

`Secrets.plist` is listed in `.gitignore`, so your key stays out of version
control. Note that a key shipped inside any mobile app can be extracted from the
build — this keeps it off GitHub, which is a different thing from keeping it
secret. A production app would proxy the request through a backend.

New keys can take a couple of hours to activate. Until one is set, the app runs
and tells you what is missing rather than failing silently.

### 3. Run

Build and run in the iOS Simulator or on a device. Location access is optional —
the city search works without it.

## Tests

```sh
xcodebuild -project WeatherApp.xcodeproj -scheme WeatherApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' test
```

19 tests, no mocking framework — each protocol has a hand-written mock in
`WeatherAppTests/Mocks/`. The suite covers the search-history use case, the
repository, the location service, and the view model, including the two cases
worth pinning down: a denied location permission shows the permission view rather
than an error, and every other location failure does the opposite.

## Acknowledgements

- Special thanks to Uncle Bob Martin for the concept of Clean Architecture.
