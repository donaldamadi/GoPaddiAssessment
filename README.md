# GoPaddi Trip Planner iOS App

A production-quality iOS trip planning application built as a technical assessment, demonstrating clean MVVM architecture with a SwiftUI + UIKit hybrid approach.

## 🚀 Quick Start

### Prerequisites

- Xcode 16.0+
- iOS 16.0+ deployment target
- macOS Sonoma or later

### Setup & Run

1. Clone this repository
2. Open `GoPaddi.xcodeproj` in Xcode
3. Select an iPhone simulator (iPhone 15/16 recommended)
4. Press `Cmd + R` to build and run

> **No external dependencies or CocoaPods needed** — the project uses only Apple frameworks.

---

## 📱 Features

### Core Functionality

| Feature             | Description                                                               |
| ------------------- | ------------------------------------------------------------------------- |
| **Plan a Trip**     | Landing screen with hero section, trip form card, and trip list           |
| **City Search**     | Full-screen searchable city selector with country flags                   |
| **Date Picker**     | Custom calendar with start/end date validation                            |
| **Create Trip**     | Bottom sheet form with trip name, travel style selection, and description |
| **Trip Detail**     | Comprehensive trip view with itinerary sections (built in UIKit)          |
| **CRUD Operations** | Full Create, Read, Update, Delete via Beeceptor mock API                  |

### Screens Implemented

1. **Plan a Trip** (SwiftUI) — Main landing page
2. **City Search** (SwiftUI) — Destination selection with search
3. **Date Picker** (SwiftUI) — Custom calendar grid
4. **Create Trip** (SwiftUI) — Trip creation form with travel style chips
5. **Trip Detail** (UIKit) — Programmatic UIKit with itinerary sections
6. **Trip Cards** (SwiftUI) — Scrollable trip list with city badges
7. **About Screen** (Storyboard) — App info screen demonstrating storyboard usage

### Testing

- **Unit Tests** — logic tests for `Trip` model and `TripListViewModel` using XCTest.

## 🏗 Architecture

### MVVM Pattern

```
┌───────────────┐     ┌──────────────┐     ┌─────────────┐
│     Views      │ ──▶ │  ViewModels   │ ──▶ │   Services   │
│  (SwiftUI/UIKit)│     │ (@Published)  │     │ (APIClient)  │
└───────────────┘     └──────────────┘     └─────────────┘
                                                  │
                                            ┌─────▼──────┐
                                            │   Models    │
                                            │  (Codable)  │
                                            └────────────┘
```

### Project Structure

```
GoPaddi/
├── Models/          → Trip, City (Codable, Identifiable)
├── Views/           → SwiftUI screens + reusable components
├── ViewModels/      → @MainActor ObservableObject VMs
├── Services/        → APIClient, TripService, NetworkError
├── UIKitIntegration/→ TripDetailViewController + Representable bridge
├── Utilities/       → DesignSystem, DateFormatters, Extensions
└── Assets.xcassets/ → Images and color assets
```

### Architecture Principles

- **Single responsibility** per class
- **Dependency injection** via protocols (`TripServiceProtocol`, `APIClientProtocol`)
- **No networking inside Views** — all API calls go through ViewModels
- **Minimal logic in ViewControllers** — UIKit VC delegates to data passed in

---

## 🌐 API Integration

### Beeceptor Mock API

**Base URL:** `https://cab23b919476dcf5db46.free.beeceptor.com`

| Method   | Endpoint      | Description          |
| -------- | ------------- | -------------------- |
| `GET`    | `/trips`      | Fetch all trips      |
| `GET`    | `/trips/{id}` | Fetch single trip    |
| `POST`   | `/trips`      | Create new trip      |
| `PUT`    | `/trips/{id}` | Update existing trip |
| `DELETE` | `/trips/{id}` | Delete trip          |

### Why Beeceptor?

Beeceptor provides a quick mock API without backend setup. **Limitations:**

- Data may not persist across sessions
- Rate limiting possible on free tier
- The app gracefully handles API failures with local fallback data

### Error Handling

- Network connectivity errors → retry option
- Decoding errors → graceful fallback
- Server errors (4xx/5xx) → user-facing error messages
- Empty states → illustrated placeholder views

---

## 🎨 SwiftUI vs UIKit

| Screen           | Framework      | Rationale                                    |
| ---------------- | -------------- | -------------------------------------------- |
| Plan a Trip      | SwiftUI        | Declarative UI ideal for reactive form state |
| City Search      | SwiftUI        | List rendering with Combine search           |
| Date Picker      | SwiftUI        | Custom calendar grid with state bindings     |
| Create Trip      | SwiftUI        | Form validation with @Published properties   |
| **Trip Detail**  | **UIKit**      | Demonstrates programmatic UIKit proficiency  |
| **About Screen** | **Storyboard** | Demonstrates Interface Builder proficiency   |

### UIKit Integration

The Trip Detail screen uses `UIViewControllerRepresentable` to bridge a fully programmatic `TripDetailViewController` into the SwiftUI navigation stack. The About screen demonstrates loading a `UIViewController` from a `.storyboard` file. This demonstrates:

- Programmatic Auto Layout constraints
- UIScrollView with stacked content
- UIButton.Configuration for modern button styling
- UIMenu for context menus
- Proper UIKit ↔ SwiftUI communication via closures

---

## ⚖️ Trade-offs

| Decision                      | Rationale                                               |
| ----------------------------- | ------------------------------------------------------- |
| No third-party libraries      | Assessment focus — demonstrates Apple framework mastery |
| Static city list              | No geocoding API needed; easily extensible              |
| Local fallback on API failure | Beeceptor may be unreliable; UX should still work       |
| SF Symbols for icons          | Consistent, scalable, accessibility-ready               |
| Deployment target iOS 16+     | Balances modern APIs with broad device support          |

---

## ♿ Accessibility

- **Dynamic Type** support via system fonts
- **Accessibility labels** on all interactive elements
- **VoiceOver** friendly navigation structure
- **Proper contrast ratios** for text and interactive elements
- **Minimum 44pt touch targets** for buttons

---

## 📝 Known Limitations

1. **Beeceptor mock API** — data doesn't persist; API may rate-limit
2. **Images are placeholder** — intended to be replaced with production assets
3. **Itinerary items** (flights, hotels, activities) are display-only empty states
4. **Offline support** not implemented (would use Core Data or SwiftData)
5. **Unit tests** — test targets exist but tests not yet written

---

## 📋 Suggested Commit Strategy

```
1. feat: initial project setup and architecture foundation
2. feat: add models and networking layer (APIClient, TripService)
3. feat: implement ViewModels with CRUD operations
4. feat: build Plan a Trip landing screen (SwiftUI)
5. feat: add city search and date picker screens
6. feat: create trip form with travel style selection
7. feat: implement trip detail screen (UIKit)
8. feat: add UIKit-SwiftUI bridge and navigation
9. chore: add image assets and design system
10. docs: add comprehensive README
```

---

## 🔧 Libraries Used

**None** — this project uses only Apple's first-party frameworks:

- SwiftUI
- UIKit
- Combine
- Foundation

---

## 📄 License

This project was built as a technical assessment and is not licensed for production distribution.
