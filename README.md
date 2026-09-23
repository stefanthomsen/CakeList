# Cake List App

A simple iOS app that loads and displays a list of cakes from a remote API.

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

## Author

Stefan Grandjean-Thomsen  
September 2026
