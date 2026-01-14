# Nuryev App - MVVM Architecture

## Project Structure

```
lib/
├── main.dart                          # App entry point with Provider setup
├── models/
│   └── subscription_model.dart        # Data model for subscription
├── services/
│   └── storage_service.dart           # Local storage (SharedPreferences)
├── view_models/
│   ├── app_view_model.dart           # Main app state management
│   └── paywall_view_model.dart       # Paywall screen state
└── views/
    ├── app_router.dart                # Navigation routing
    ├── onboarding/
    │   ├── onboarding_screen.dart    # Onboarding container
    │   ├── onboarding_page1.dart     # Welcome page
    │   └── onboarding_page2.dart     # Features page
    ├── paywall/
    │   ├── paywall_screen.dart       # Paywall container
    │   └── subscription_card.dart    # Reusable subscription card
    └── main_screen/
        └── main_screen.dart           # Home screen
```

## Architecture Overview

### Models (`lib/models/`)
- **SubscriptionModel**: Contains subscription data (plan, dates, status)
- Clean data representation with `toJson()` and `fromJson()` methods

### Services (`lib/services/`)
- **StorageService**: Handles all local data persistence
- Encapsulates SharedPreferences logic
- Provides clean API for getting/saving subscription data
- Calculates end dates based on subscription plan

### ViewModels (`lib/view_models/`)
- **AppViewModel**: 
  - Main app state (has_subscription, subscription details)
  - Extends `ChangeNotifier` for reactive updates
  - Handles initialization, subscription purchase, logout
  
- **PaywallViewModel**:
  - Manages paywall UI state (selected plan, loading state)
  - Simulates purchase process

### Views (`lib/views/`)
- **AppRouter**: Main navigation and route setup with Provider
- **Onboarding**: Two-page PageView with smooth transitions
- **Paywall**: Plan selection with responsive layout (side-by-side on desktop)
- **MainScreen**: Shows subscription details and benefits

## Key Features

1. **Separation of Concerns**: Logic, state, and UI are clearly separated
2. **Reactive State Management**: Using Provider for efficient rebuilds
3. **Responsive Design**: Adapts to mobile and desktop screens
4. **Persistent State**: Subscription saved to local storage via StorageService
5. **Clean Navigation**: Named routes and proper state transitions

## Flow

1. App initializes → checks subscription state
2. If no subscription → OnboardingScreen → PaywallScreen
3. After purchase → saves to StorageService → MainScreen
4. On next app launch → skips onboarding, goes directly to MainScreen
5. Logout clears storage → returns to OnboardingScreen

## State Management with Provider

- `StorageService`: Provides access to persistent storage
- `AppViewModel`: Notifies UI of state changes
- `Consumer` widgets listen to ViewModel changes for reactive updates

## Benefits of This Structure

✅ **Testability**: Each layer can be tested independently
✅ **Maintainability**: Clear separation makes changes easier
✅ **Scalability**: Easy to add new features/screens
✅ **Reusability**: ViewModels and Services can be reused
✅ **Performance**: Provider only rebuilds affected widgets
