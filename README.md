# WeatherApp

WeatherApp is a SwiftUI application that follows the principles of Clean Architecture. This architecture separates concerns into distinct layers, making the codebase more maintainable, testable, and scalable.

For a detailed explanation of the implementation, you can refer to the [Clean Architecture in SwiftUI article on Medium](https://medium.com/@mo.fawzy/clean-architecture-in-swiftui-4eb33a187cdc) story.

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
│   ├── Repositories/
│   │   ├── WeatherRepository.swift
│   │   └── SearchHistoryRepository
│   ├── DataSources/
│   │   ├── Remote/
│   │   │   └── WeatherRemoteDataSource.swift
│   │   └── Local/
│   │       ├── SearchHistoryLocalDataSource.swift
│   │       └── WeatherLocalDataSource.swift
│   ├── Services/
│   │   └── LocationService.swift
│   └── Models/
│       └── WeatherResponseDTO.swift
│       └── WeatherLocal.Swift
└── Presentation/
    ├── Views/
    │   ├── WeatherView.swift
    │   ├── WeatherContentView.swift
    │   ├── SearchView.swift
    │   └── Components/
    │       ├── WeatherCardView.swift
    │       ├── ErrorView.swift
    │       ├── LocationPermissionInfoView.swift
    │       └── LoadingView.swift
    ├── ViewModels/
    │   └── WeatherViewModel.swift
    └── UIModels/
        └── WeatherUIModel.swift
```

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

## Acknowledgements

- Special thanks to Uncle Bob Martin for the concept of Clean Architecture.
