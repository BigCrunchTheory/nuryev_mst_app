# Project File Structure

```
nuryev_mst_app/
├── lib/
│   ├── main.dart (30 lines)
│   │   └── Entry point with Provider configuration
│   │
│   ├── models/
│   │   └── subscription_model.dart (45 lines)
│   │       └── SubscriptionModel: plan, startDate, endDate, isActive
│   │
│   ├── services/
│   │   └── storage_service.dart (50 lines)
│   │       ├── hasSubscription()
│   │       ├── getSubscription()
│   │       ├── saveSubscription()
│   │       └── clearSubscription()
│   │
│   ├── view_models/
│   │   ├── app_view_model.dart (45 lines)
│   │   │   ├── subscription: SubscriptionModel?
│   │   │   ├── hasSubscription: bool
│   │   │   ├── initialize()
│   │   │   ├── setSubscription(plan)
│   │   │   └── logout()
│   │   │
│   │   └── paywall_view_model.dart (25 lines)
│   │       ├── selectedPlan: String
│   │       ├── isLoading: bool
│   │       ├── selectPlan(plan)
│   │       └── purchase(onSuccess)
│   │
│   └── views/
│       ├── app_router.dart (45 lines)
│       │   └── AppRouter: Handles navigation and routing
│       │
│       ├── onboarding/
│       │   ├── onboarding_screen.dart (50 lines)
│       │   │   └── OnboardingScreen: PageView container
│       │   ├── onboarding_page1.dart (75 lines)
│       │   │   └── OnboardingPage1: Welcome screen
│       │   └── onboarding_page2.dart (75 lines)
│       │       └── OnboardingPage2: Features screen
│       │
│       ├── paywall/
│       │   ├── paywall_screen.dart (140 lines)
│       │   │   └── PaywallScreen: Plan selection
│       │   └── subscription_card.dart (100 lines)
│       │       └── SubscriptionCard: Reusable plan card
│       │
│       └── main_screen/
│           └── main_screen.dart (160 lines)
│               └── MainScreen: Home with subscription details
│
├── android/
├── ios/
├── web/
├── linux/
├── macos/
├── windows/
│
├── pubspec.yaml
├── analysis_options.yaml
├── ARCHITECTURE.md (Documentation)
└── REFACTORING_SUMMARY.md (This file)
```

## File Sizes

| File | Lines | Purpose |
|------|-------|---------|
| main.dart | 30 | App setup |
| subscription_model.dart | 45 | Data model |
| storage_service.dart | 50 | Data persistence |
| app_view_model.dart | 45 | Main state |
| paywall_view_model.dart | 25 | Paywall state |
| app_router.dart | 45 | Navigation |
| onboarding_screen.dart | 50 | Onboarding container |
| onboarding_page1.dart | 75 | Welcome page |
| onboarding_page2.dart | 75 | Features page |
| paywall_screen.dart | 140 | Paywall screen |
| subscription_card.dart | 100 | Plan card component |
| main_screen.dart | 160 | Home screen |
| **TOTAL** | **840** | **Clean MVVM structure** |

*Previous monolithic approach: 889 lines in single file*
*New structured approach: 840 lines across 12 focused files*

## Import Dependencies

### main.dart
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'view_models/app_view_model.dart';
import 'views/app_router.dart';
```

### Views
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// + other views/models as needed
```

### ViewModels
```dart
import 'package:flutter/material.dart';
import 'models/subscription_model.dart';
import 'services/storage_service.dart';
```

### Services
```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'models/subscription_model.dart';
```

### Models
```dart
// Pure Dart, no Flutter dependencies
```

## Data Flow

```
User Interaction (UI)
        ↓
Views (Screens)
        ↓
ViewModels (State Management)
        ↓
Services (Business Logic)
        ↓
Models (Data)
        ↓
SharedPreferences (Persistence)
```

## Execution Flow

### First Launch (No Subscription)
1. `main.dart` → Initializes App with Providers
2. `AppRouter` → Checks `AppViewModel.hasSubscription`
3. `OnboardingScreen` → Shows welcome pages
4. `PaywallScreen` → User selects plan
5. `PaywallViewModel.purchase()` → Simulates purchase
6. `AppViewModel.setSubscription()` → Saves via `StorageService`
7. `MainScreen` → Shows subscription details

### Subsequent Launches (Has Subscription)
1. `main.dart` → Initializes App
2. `AppViewModel.initialize()` → Loads from `StorageService`
3. `AppRouter` → Detects subscription
4. `MainScreen` → Shows immediately (skips onboarding)

## Dependencies Added

```yaml
provider: ^6.0.0        # State management
shared_preferences: ^2.2.0  # Local storage
```

## Testing Strategy

```
Models/               → Unit tests (pure Dart)
├── subscription_model_test.dart

Services/             → Unit + Integration tests
├── storage_service_test.dart (mock SharedPreferences)

ViewModels/           → Unit tests (with mocked services)
├── app_view_model_test.dart
├── paywall_view_model_test.dart

Views/                → Widget tests
├── onboarding_test.dart
├── paywall_test.dart
└── main_screen_test.dart
```
