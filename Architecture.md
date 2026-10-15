# Bedal — Application Architecture

Bedal strictly adheres to **Clean Architecture** and **Separation of Concerns (SoC)** guidelines. By splitting our presentation components entirely from state machines and remote network adapters, we guarantee an ultra-lean memory footprint and effortless scalability as our platform expands cross-border.

## Overview

Bedal is built with Flutter and Dart, using Provider for state management and Firebase for backend services.
The application follows a modular architecture that separates the user interface, application state, business logic, and data access. This structure makes the codebase easier to maintain, test, and expand as Bedal grows.

## Project Structure

```
lib/
│
├── models/                 # Data models and serialization
│   └── auth/
│       └── user_profile_model.dart
│
├── providers/              # State management and UI state
│   └── signup_provider.dart
│
├── services/               # External and device-related services
│   └── auth/
│       └── location_service.dart
│
├── repositories/           # Data access and backend operations
│   └── auth/
│       ├── auth_service.dart
│       └── security_service.dart
│
├── screens/                # Application screens
│   ├── onboarding/
│   │   └── splash_screen.dart
│   ├── chat/
│   │   └── swap/
│   ├── home/
│   ├── explore/
│   ├── profile/
│   └── hubs/
│
├── widgets/                # Shared, reusable UI components
│
└── main.dart               # Application entry point
```

## Folder Responsibilities

### `models/` — Data Structure
Contains strongly typed Dart classes representing application data, such as user profiles, skills, messages, and notifications.
Models define how data is represented and, when needed, serialized or deserialized.

### `providers/` — State Management
Contains Provider classes, typically using `ChangeNotifier`, to manage application state and notify the UI when relevant data changes.
Example: `signup_provider.dart`.

### `services/` — Service Integrations
Contains reusable services for specific operations, including device features and integrations with external APIs.
Example: `location_service.dart` handles location-related functionality and reverse geocoding when configured.

### `repositories/` — Data Access
Contains the data-access layer responsible for retrieving, creating, updating, and deleting application data through Firebase or other configured data sources.
Repositories help keep database operations separate from UI screens and state-management classes.

### `screens/` — Presentation Layer
Contains the main screens and screen-specific UI components, organized by feature.
Examples include Home, Explore, Profile, Chat, Hubs, and onboarding.

### `widgets/` — Shared UI Components
Contains reusable visual components used across multiple screens, such as custom buttons, input fields, cards, and shared interface elements.

### `main.dart` — Application Entry Point
Initializes the application, configures required dependencies such as Firebase, registers global Provider instances, and launches the root widget.

## Architecture Principles
Bedal follows these principles:
- **Separation of concerns:** Each layer has a clearly defined responsibility.
- **Reusability:** Shared logic and widgets should not be unnecessarily duplicated.
- **Maintainability:** Features should be organized into understandable modules.
- **Testability:** Business logic and data access should be testable independently of the UI.
- **Security:** Authentication, authorization, and database access rules must be enforced appropriately.

## Typical Data Flow
```
User Interaction
       ↓
Screen / Widget
       ↓
Provider
       ↓
Repository
       ↓
Firebase
```

Services may support individual operations, such as retrieving device location or interacting with external APIs.
The exact flow may vary depending on the feature.

## 📊 Core Technology Stack Matrix

| Technology | Architectural Operational Purpose |
| :--- | :--- |
| **Flutter** | High-performance, cross-platform mobile application engine |
| **Dart** | Core application programming language and runtime system |
| **Firebase** | Root scalable cloud backend infrastructure |
| **Firebase Authentication** | Secure user registration, identity gating, and email verification links |
| **Cloud Firestore** | Live application database, time-banking ledgers, and profile schemas |
| **Firebase Storage** | Heavy media hosting bucket for 30s skill clips and profile assets |
| **Provider** | Reactive state management layer and decoupled view-model broadcasting |
| **Android Studio** | Primary unified development environment (IDE) and compiler pipeline |
| **GitHub** | Secure distributed version control and collaborative code tracking |

---

## 🛠️ Project Execution & Build Environment Configuration

To launch the development client tracker pipeline on your attached emulator or physical hardware, execute the following commands inside your root directory terminal:

```bash
# 1. Clean build cache and restore localized package links
flutter clean
flutter pub get

# 2. Compile and run the active debug build matrix
flutter run
```

*Note: Compile-time environmental parameter overrides (such as overriding local city tracking strings for dashboard development) can be safely injected via command variables:*
```bash
flutter run --dart-define=TEST_CITY=Jeddah
```
