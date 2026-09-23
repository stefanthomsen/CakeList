# Cake List App

A simple iOS app that loads and displays a list of cakes from a remote API.

## Screenshots

| Loaded | Loading | Error |
|--------|---------|-------|
| <img src="https://github.com/user-attachments/assets/e6753c03-c8c7-406d-a462-3c2af6fbdfd8" width="200" /> | <img src="https://github.com/user-attachments/assets/be11b3e2-11f2-4d27-9139-2e9e7d0f0ac0" width="200" /> | <img src="https://github.com/user-attachments/assets/4cb08126-e8f3-4a97-b180-d9ad532c28cf" width="200" /> |

## Architecture

Built using **MVVM** (Model-View-ViewModel) pattern with clean separation of concerns:

- **Models**: `Cake.swift` — Decodable data model with `Identifiable` and `Hashable` conformance
- **Services**: `CakeService.swift` — Handles API calls and data processing
- **ViewModels**: `CakeListViewModel.swift` — Business logic, state management
- **Views**: SwiftUI components for list, row, and detail display
- **State Management**: `ViewState` enum for loading/loaded/error states

## Features

### ✅ Must Have (Implemented)
- [x] Load cakes from API endpoint
- [x] Remove duplicate entries
- [x] Sort by name (alphabetically)
- [x] Display image and title for each cake
- [x] Divider between entries
- [x] Tap to show description in bottom sheet
- [x] Refresh button to reload list
- [x] Error handling with retry option

### 🎁 Nice to Have (Implemented)
- [x] Handle orientation changes (no reload)
- [x] Retry option on error
- [x] Bottom sheet with `.presentationDetents`

## Project Structure

```
CakeList/
├── App/
│   └── CakeListAppApp.swift
├── Models/
│   └── Cake.swift
├── ViewModels/
│   └── CakeListViewModel.swift
├── Views/
│   ├── CakeListView.swift
│   ├── CakeRowView.swift
│   └── CakeDetailView.swift
├── Services/
│   └── CakeService.swift
├── Resources/
│   └── Constants.swift
└── Common/
    └── ViewState.swift

CakeListTests/
├── CakeListViewModelTests.swift
└── CakeServiceTests.swift
```

## How to Run

1. Open `CakeList.xcodeproj` in Xcode
2. Select iOS simulator or device
3. Press `Cmd + R` to build and run

## Testing

Unit tests using **Swift Testing** framework:

```bash
Cmd + U  # Run tests in Xcode
```

Tests cover:
- Load success + deduplication + sorting
- Load failure + error handling
- Retry functionality

## API

**Endpoint**: `https://raw.githubusercontent.com/Waracle/mobile-coding-test-api/refs/heads/main/cakes`

**Data Model**:
```json
[
  {
    "title": "Cake Name",
    "desc": "Description",
    "image": "image_url"
  }
]
```

## Key Decisions

- **Hashable + Equatable**: Automatic deduplication using `Set<Cake>`
- **ViewState enum**: Clean state management (loading/loaded/error)
- **Protocol-based services**: Testable with mocks
- **Swift Testing**: Modern, expressive test syntax
- **Bottom sheet**: `.presentationDetents([.medium, .large])` for flexible UI

## TODOs

- [ ] Add pull-to-refresh animation
- [ ] Image caching strategy (URLCache or 3rd party library)
- [ ] Pagination for large lists
- [ ] Offline support with local persistence
- [ ] Search/filter functionality
- [ ] Detail view image optimization

## Git Commits

See commit history for step-by-step development:
1. Initial project setup + models
2. CakeService + API integration
3. CakeListViewModel (business logic)
4. Views (list + row + detail)
5. Error handling + refresh
6. Unit tests
7. Cleanup + TODOs

## AI Disclosure

This project was developed with assistance from Claude AI. The following were built with AI support:
- Architecture & MVVM pattern setup
- View and ViewModel structure
- Unit tests framework
- MockCakeService implementation
- Documentation

However, all code was reviewed, tested, and refined to ensure quality and correctness. The implementation demonstrates understanding of iOS best practices, SwiftUI, and clean architecture principles.

## Author

Stefan Grandjean-Thomsen  
September 2026
