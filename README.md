# 🤝 Hack Volunteers

> Flutter mobile application for discovering volunteer opportunities through Tinder-style swipe mechanics

[![Flutter](https://img.shields.io/badge/Flutter-3.9%2B-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9%2B-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Educational-green.svg)](LICENSE)

## 📋 About

Hack Volunteers is a mobile application designed to connect youth with volunteer opportunities in Kraków. Users can browse through volunteer events and express interest through intuitive swipe gestures:

- 👉 **Swipe right** → Interested
- 👈 **Swipe left** → Skip

The application aims to make volunteering more accessible and engaging for young people while helping organizations find enthusiastic volunteers.

## ✨ Features

### Current (v0.1.0)
- ✅ Tinder-style swipe mechanics for browsing events
- ✅ Detailed event information cards
- ✅ Interest tracking system
- ✅ Smooth animations and transitions
- ✅ Responsive UI design
- ✅ Local data persistence (in-memory)

### Planned
- � Isar local database integration
- 🔄 Firebase Authentication
- � Cloud Firestore integration
- � User profile management
- 📋 Event filtering and search
- 📋 Personal calendar integration
- 📋 Push notifications
- 📋 Volunteer certificates
- 📋 Organization portal
- 📋 School coordinator dashboard

## 🏗️ Architecture

This project follows **Clean Architecture** principles with strict separation of concerns:

```
lib/
├── core/                    # Shared utilities
│   ├── error/              # Error handling
│   ├── network/            # Network utilities
│   └── usecases/           # Base use case
├── features/
│   ├── events/
│   │   ├── domain/         # Business logic (entities, repositories, use cases)
│   │   ├── data/           # Data layer (models, datasources, repository impl)
│   │   └── presentation/   # UI layer (BLoC, widgets, pages)
│   └── local_storage/      # Isar database integration
└── injection_container.dart # Dependency injection setup
```

### Design Patterns

- **Clean Architecture**: Domain, Data, and Presentation layers
- **SOLID Principles**: Single responsibility, dependency inversion, etc.
- **BLoC Pattern**: State management with events and states
- **Repository Pattern**: Abstract data sources
- **Dependency Injection**: Using GetIt service locator

## 🛠️ Tech Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **Framework** | Flutter | 3.9+ |
| **Language** | Dart | 3.9+ |
| **State Management** | flutter_bloc | 8.1.6 |
| **Dependency Injection** | get_it | 7.7.0 |
| **Functional Programming** | dartz | 0.10.1 |
| **Local Database** | isar | 3.1.0 |
| **Value Equality** | equatable | 2.0.5 |
| **Date Formatting** | intl | 0.19.0 |
| **Path Provider** | path_provider | 2.1.4 |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9 or higher
- Dart SDK 3.9 or higher
- Android Studio / VS Code with Flutter extensions
- Android SDK or Xcode (for iOS)

### Installation

```bash
# Clone the repository
git clone https://github.com/PawelG1/hack-volunteers.git
cd hack-volunteers

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build

```bash
# Debug build (development)
flutter run

# Release build (production)
flutter build apk --release          # Android
flutter build ios --release          # iOS
```

## 📖 Documentation

For detailed documentation, see:

- [**QUICK_START.md**](QUICK_START.md) - Quick start guide
- [**PROJECT_ARCHITECTURE.md**](PROJECT_ARCHITECTURE.md) - Architecture details
- [**PROJECT_VISION.md**](PROJECT_VISION.md) - Complete project vision
- [**ISAR_IMPLEMENTATION.md**](ISAR_IMPLEMENTATION.md) - Database implementation
- [**OPTIMIZATION.md**](OPTIMIZATION.md) - Performance optimization
- [**COMMANDS.md**](COMMANDS.md) - Useful commands reference

## 🧪 Testing

```bash
# Run static analysis
flutter analyze

# Format code
dart format .

# Run tests (when available)
flutter test
```

## � Screenshots

*Coming soon*

## 🤝 Contributing

This is an educational project. Contributions, issues, and feature requests are welcome!

## 📄 License

Educational project - Hack Volunteers

## 👥 Authors

**PawelG1** - [GitHub Profile](https://github.com/PawelG1)

---

**Made with ❤️ for volunteers in Kraków**
