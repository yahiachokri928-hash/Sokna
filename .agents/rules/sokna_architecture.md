---
trigger: always_on
description: "Mandatory Clean Architecture, BLoC, DI, Routing and ISET Bizerte specification rules for the Sokna Flutter project."
---

# SOKNA (سكنى) — Architectural & Implementation Rules

You are building the **Sokna** Flutter mobile application (ISET Bizerte — DSI 3, student: Yahia Chokri, repo: https://github.com/yahiachokri928-hash/Sokna).
NEVER delete or modify the existing `documents uni/` folder or `.gitattributes`.

## 1. Locked Tech Stack (`pubspec.yaml`)
- **SDK:** Dart `^3.9.2` / Flutter Material 3 (`useMaterial3: true`)
- **State Management:** `flutter_bloc` (`Bloc<Event, State>` only — do NOT use Cubit, Provider, or Riverpod)
- **Value Equality:** `equatable` (all Entities, Failures, Events, States)
- **Functional Error Handling:** `dartz` (`Either<Failure, T>`, `Unit`, `Right`, `Left`, `.fold(...)`)
- **Dependency Injection:** `get_it` (`final sl = GetIt.instance;`)
- **Navigation:** `go_router` (`AppRouter` + `ShellRoute` + `GoRouterRefreshNotifier`)
- **REST API & Connectivity:** `http` + `internet_connection_checker` (`NetworkInfo` / `NetworkInfoImpl`)
- **Local Persistence:** `shared_preferences`
- **Auth / Backend:** `firebase_core`, `firebase_auth`, `cloud_firestore`
- **Validation & Web:** `validators`, `package:flutter_web_plugins/flutter_web_plugins.dart`
- **Lints:** `flutter_lints` (`flutter analyze` must pass with 0 errors/warnings)

## 2. Exact Directory Structure (`lib/`)
One widget per file (`ENF4`). Do NOT create folders outside `core/` and `features/`.

```text
lib/
├── main.dart
├── firebase_options.dart
├── core/
│   ├── di/
│   │   └── service_locator.dart
│   ├── exceptions/
│   │   └── exceptions.dart
│   ├── failures/
│   │   ├── failures.dart
│   │   ├── auth_failures.dart
│   │   └── listing_failures.dart
│   ├── firebase/
│   │   ├── auth_service.dart
│   │   └── firestore_service.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── router/
│   │   ├── app_router.dart
│   │   └── routes.dart
│   ├── strings/
│   │   ├── failures.dart
│   │   └── messages.dart
│   ├── themes/
│   │   ├── color_manager.dart
│   │   ├── font_manager.dart
│   │   └── theme_manager.dart
│   ├── utils/
│   │   └── snack_bar_message.dart
│   └── widgets/
│       └── loading_widget.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/user_data_source.dart
    │   │   ├── models/user_model.dart
    │   │   └── repositories/user_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/user_entity.dart
    │   │   ├── repositories/user_repository.dart
    │   │   └── usecases/
    │   │       ├── register_user.dart
    │   │       ├── sign_in_user.dart
    │   │       ├── sign_out_user.dart
    │   │       ├── update_user.dart
    │   │       └── get_current_user_profile.dart
    │   └── presentation/
    │       ├── blocs/
    │       │   ├── auth/{auth_bloc.dart, auth_event.dart, auth_state.dart}
    │       │   └── register/{register_bloc.dart, register_event.dart, register_state.dart}
    │       ├── screens/{login_screen.dart, register_screen.dart, profile_screen.dart}
    │       └── widgets/{auth_btn.dart, login_form.dart, register_form.dart}
    ├── listings/
    │   ├── data/
    │   │   ├── datasources/listing_data_source.dart
    │   │   ├── models/listing_model.dart
    │   │   └── repositories/listing_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/listing_entity.dart
    │   │   ├── repositories/listing_repository.dart
    │   │   └── usecases/
    │   │       ├── get_listings.dart
    │   │       ├── search_listings.dart
    │   │       └── add_listing.dart
    │   └── presentation/
    │       ├── blocs/
    │       │   ├── listings/{listings_bloc.dart, listings_event.dart, listings_state.dart}
    │       │   └── theme/{switchtheme_bloc.dart, switchtheme_event.dart, switchtheme_state.dart}
    │       ├── screens/
    │       │   ├── home_screen.dart
    │       │   ├── search_screen.dart
    │       │   ├── listing_detail_screen.dart
    │       │   └── post_listing_screen.dart
    │       └── widgets/
    │           ├── listing_card.dart
    │           ├── category_filter_bar.dart
    │           ├── amenity_badge.dart
    │           ├── custom_empty_state.dart
    │           ├── post_listing_form.dart
    │           └── toolbar_action_theme_widget.dart
    └── favorites/
        ├── data/
        │   ├── datasources/favorites_local_data_source.dart
        │   └── repositories/favorites_repository_impl.dart
        ├── domain/
        │   ├── repositories/favorites_repository.dart
        │   └── usecases/
        │       ├── get_saved_listing_ids.dart
        │       └── toggle_saved_listing.dart
        └── presentation/
            ├── blocs/
            │   └── saved_listings/{saved_listings_bloc.dart, saved_listings_event.dart, saved_listings_state.dart}
            └── screens/
                └── saved_screen.dart
```

## 3. Strict Layer Boundaries & BLoC Safety Rules
1. **`domain/` (Pure Dart):** Allowed imports: `dart:*`, `equatable`, `dartz`, `core/failures/*`, and `domain/`. Forbidden: `flutter/*`, `http`, `shared_preferences`, `firebase_*`, `cloud_firestore`, `data/*`, `presentation/*`.
2. **`data/`:** Allowed: `domain/*`, `core/*`, external SDKs (`http`, `shared_preferences`, `firebase_*`, `cloud_firestore`, `dartz`). Forbidden: `presentation/*`, `flutter/material.dart`.
3. **`presentation/`:** Allowed: `domain/*`, `core/*`, `flutter/*`, `flutter_bloc`, `go_router`, `validators`. Forbidden: `*Model`, `*DataSource`, `*RepositoryImpl`, `FirebaseFirestore`, `cloud_firestore`.
4. **Cloud & Firestore Scope:** `FirebaseFirestore` is only accessed inside `core/firebase/` and `features/*/data/` (never in `domain/` or `presentation/`).
5. **Modern BLoC Rules:**
   - Use ONLY `on<Event>((event, emit) async { ... })`. Never override deprecated `mapEventToState`.
   - Never call `emit()` inside a stream `.listen(...)` callback; dispatch an internal event instead.
   - Split every BLoC into 3 files connected with `part` and `part of`.
6. **Strings, Theme & Layout (`ENF1`, `ENF2`, `ENF3`):**
   - Zero hardcoded French UI strings or validation messages in widgets/BLoCs: centralize all strings as `const String` (`SCREAMING_SNAKE_CASE`) in `lib/core/strings/failures.dart` and `lib/core/strings/messages.dart`.
   - Zero hardcoded hex colors in widgets: use `Theme.of(context).colorScheme` seeded from `ColorManager.seedColorLight = Color(0xFF1A6B5A)` (Deep Teal).
   - Use `8 / 16 / 24 dp` spacing, `Montserrat` font, minimum `48x48 dp` touch targets, and `SingleChildScrollView` / `ListView.builder` so portrait mode never overflows.