# Project Structure

This document outlines the complete folder and file structure of the Ape Archive mobile app.

## Directory Tree

```
ape-archive-mobile/
├── android/                              # Android platform files
│   ├── app/
│   │   ├── build.gradle.kts              # Android build configuration (Java 21)
│   │   └── src/                          # Android source code
│   ├── gradle.properties                  # Gradle properties (JDK 21 path)
│   └── settings.gradle.kts
│
├── ios/                                   # iOS platform files
│   ├── Runner/
│   └── Runner.xcodeproj/
│
├── lib/                                   # Dart application code
│   ├── core/                              # Core infrastructure layer
│   │   ├── constants/
│   │   │   ├── api_constants.dart         # API endpoints & configuration
│   │   │   └── storage_keys.dart          # Storage key constants
│   │   ├── error/
│   │   │   ├── failures.dart              # Failure classes
│   │   │   └── exceptions.dart            # Exception classes
│   │   ├── network/
│   │   │   └── dio_client.dart            # Dio HTTP client with interceptors
│   │   ├── storage/
│   │   │   └── secure_storage_service.dart # Secure storage wrapper
│   │   └── utils/                          # Utility functions (to be added)
│   │
│   ├── features/                          # Feature modules
│   │   ├── auth/                          # Authentication feature
│   │   │   ├── data/
│   │   │   │   ├── models/                # User, Token models (to be added)
│   │   │   │   ├── providers/             # Riverpod providers (to be added)
│   │   │   │   └── repositories/          # Auth repository (to be added)
│   │   │   └── presentation/
│   │   │       ├── screens/               # Login, Splash screens (to be added)
│   │   │       └── widgets/               # Auth-related widgets (to be added)
│   │   │
│   │   ├── library/                       # Library browsing feature (to be added)
│   │   ├── resources/                     # PDF viewer feature (to be added)
│   │   ├── forum/                         # Forum/Q&A feature (to be added)
│   │   ├── teachers/                      # Teacher discovery (to be added)
│   │   └── profile/                       # User profile (to be added)
│   │
│   ├── shared/                            # Shared/common components
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # Color palette (light/dark)
│   │   │   ├── app_text_styles.dart       # Typography definitions
│   │   │   └── app_theme.dart             # Material 3 theme configuration
│   │   ├── widgets/                        # Reusable widgets (to be added)
│   │   └── l10n/                          # Localization files (to be added)
│   │
│   └── main.dart                           # App entry point with HomeScreen
│
├── test/                                   # Unit and widget tests
│   └── widget_test.dart                    # Basic app smoke test
│
├── assets/                                 # Static assets
│   ├── images/                             # Image files (placeholder)
│   ├── icons/                              # Icon files (placeholder)
│   ├── animations/                         # Lottie animations (placeholder)
│   ├── translations/                       # i18n translation files (placeholder)
│   └── fonts/                              # Source Sans Pro fonts (to be added)
│
├── docs/                                   # Documentation
│   ├── API_MAPPING.md                      # Complete API documentation
│   └── DESIGN_SYSTEM.md                    # Design system specification
│
├── .vscode/
│   └── launch.json                         # VS Code debug configuration
│
├── pubspec.yaml                            # Dart dependencies
├── README.md                               # Project documentation
└── analysis_options.yaml                   # Linter configuration
```

## Key Files

### Configuration Files

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dart package dependencies and project metadata |
| `android/gradle.properties` | Gradle properties (JDK 21 path) |
| `android/app/build.gradle.kts` | Android build configuration (Java 21 target) |
| `analysis_options.yaml` | Dart linter rules |
| `.vscode/launch.json` | Flutter debug configuration for VS Code |

### Core Infrastructure

| File | Purpose |
|------|---------|
| `lib/core/constants/api_constants.dart` | API base URL, endpoints, timeouts, headers |
| `lib/core/constants/storage_keys.dart` | Keys for secure storage and shared preferences |
| `lib/core/network/dio_client.dart` | Dio HTTP client with auth interceptor and error handling |
| `lib/core/storage/secure_storage_service.dart` | Wrapper for flutter_secure_storage |
| `lib/core/error/failures.dart` | Failure classes for error handling |
| `lib/core/error/exceptions.dart` | Exception classes for error handling |

### Theme & Design

| File | Purpose |
|------|---------|
| `lib/shared/theme/app_colors.dart` | Color palette (primary #FF5733, neutral, semantic) |
| `lib/shared/theme/app_text_styles.dart` | Typography scale (Source Sans Pro) |
| `lib/shared/theme/app_theme.dart` | Material 3 theme (light & dark modes) |

### Application Entry Point

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry with Riverpod ProviderScope and MaterialApp |

### Documentation

| File | Purpose |
|------|---------|
| `docs/API_MAPPING.md` | Complete backend API documentation with models |
| `docs/DESIGN_SYSTEM.md` | Design system (colors, typography, components) |
| `README.md` | Project overview, setup instructions, architecture |

## Naming Conventions

### Files
- **Dart files:** `snake_case.dart` (e.g., `api_constants.dart`)
- **Widget files:** `snake_case.dart` (e.g., `login_screen.dart`)
- **Model files:** `snake_case.dart` (e.g., `user_model.dart`)

### Classes
- **Classes:** `PascalCase` (e.g., `AuthRepository`)
- **Widgets:** `PascalCase` (e.g., `LoginScreen`)
- **Models:** `PascalCase` (e.g., `UserModel`)

### Variables & Functions
- **Variables:** `camelCase` (e.g., `userName`)
- **Constants:** `camelCase` (e.g., `baseUrl`)
- **Private members:** `_camelCase` (e.g., `_secureStorage`)

## Next Steps

1. **Add font files:** Download Source Sans Pro and place in `assets/fonts/`
2. **Implement auth flow:** Create login screen, Google Sign-In integration, deep link handler
3. **Build library feature:** Hierarchy navigation, browse screen, filters
4. **Add PDF viewer:** Integrate Syncfusion PDF Viewer with streaming
5. **Implement localization:** Add Sinhala, Tamil, English translation files
6. **Write tests:** Unit tests for repositories, widget tests for screens

## Dependencies Summary

**Production Dependencies:** 30+  
**Dev Dependencies:** 6  
**Total:** 36+ packages

Key packages:
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `dio` - HTTP client
- `google_sign_in` - Google OAuth
- `syncfusion_flutter_pdfviewer` - PDF rendering
- `flutter_secure_storage` - Token storage
- `firebase_*` - Analytics, Crashlytics, Messaging

See `pubspec.yaml` for the complete list.
