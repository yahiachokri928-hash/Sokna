# Plan Directeur d'Exécution — Projet Sokna (سكنى)

**Établissement :** ISET Bizerte — Parcours DSI 3 (2026–2027)  
**Enseignante :** Mme Zouaghi Mounira  
**Étudiant :** Yahia Chokri  
**Dépôt GitHub :** https://github.com/yahiachokri928-hash/Sokna  

---

## Phase 1 — Initialisation, Jeu de Données JSON & Socle `lib/core/` (Jalon J0 → J1)

1. **Initialisation Flutter :**
   - Préserver intact le dossier `documents uni/` et `.gitattributes`.
   - Initialiser le projet Flutter (`flutter create . --project-name sokna --org tn.isetbizerte`).
   - Configurer `pubspec.yaml` (`flutter_bloc`, `equatable`, `dartz`, `get_it`, `go_router`, `http`, `shared_preferences`, `internet_connection_checker`, `firebase_core`, `firebase_auth`, `validators`, `flutter_web_plugins`, `flutter_lints`) + assets (`assets/images/`, `assets/data/listings.json`) + polices `Montserrat`.
2. **API REST « JSON Maison » (`assets/data/listings.json` — EF6) :**
   - Créer 16 logements tunisiens réalistes (`sokna_001` à `sokna_016`) répartis sur Tunis, La Marsa, Ariana, Bizerte, Nabeul et Sousse, couvrant `Studio`, `Appartement`, `Villa`, `Maison`.
   - Champs obligatoires : `id`, `title`, `city`, `address`, `propertyType`, `price` (int TND > 0), `rooms` (1–6), `surface` (double m²), `isFurnished` (bool), `hasParking` (bool), `imagePath`, `rating` (double), `reviewCount` (int), `ownerName`, `availableFrom` (`YYYY-MM-DD`), `description`.
3. **Couche `lib/core/` :**
   - `themes/` : `ColorManager` (`#1A6B5A`), `FontManager` (`Montserrat`), `ThemeManager` (Material 3 clair/sombre).
   - `exceptions/`, `failures/`, `strings/` (`failures.dart`, `messages.dart` en français).
   - `network/network_info.dart`, `firebase/auth_service.dart`, `utils/snack_bar_message.dart`, `widgets/loading_widget.dart`.
   - `router/` (`AppRoutes`, `AppRouter` avec `ShellRoute` et `BottomNavigationBar`), `di/service_locator.dart`, `main.dart`.

**Commits Phase 1 (4 commits) :**
- `chore(init): scaffold flutter project structure and pubspec dependencies`
- `feat(data): add 16 realistic Tunisian rental listings in assets/data/listings.json`
- `feat(core): implement Material 3 teal theme, strings, failures, network info and widgets`
- `feat(routing): configure GoRouter ShellRoute, navigation guards and get_it service locator`

---

## Phase 2 — Feature `listings` : API REST + Fallback Offline & Écrans Principaux (Jalon J1 → J2)

1. **Domain :** `ListingEntity`, `ListingRepository`, `GetListingsUseCase`, `SearchListingsUseCase`, `AddListingUseCase`.
2. **Data :**
   - `ListingModel` (`fromJson`, `toJson`, `fromEntity`).
   - `ListingDataSourceImpl` (`EF6` + `ENF3`) : consomme `https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json` via `http.get` avec bascule automatique sur `rootBundle.loadString('assets/data/listings.json')` hors ligne.
3. **Presentation :**
   - `ListingsBloc` & `SwitchthemeBloc`.
   - Widgets atomiques (1 widget par fichier — `ENF4`) : `ListingCard`, `CategoryFilterBar`, `AmenityBadge`, `CustomEmptyState`, `PostListingForm`, `ActionThemeButton`.
   - Écrans :
     - `HomeScreen` (`EF1`, `EF6`) : salutation, catégories horizontales, liste recommandée.
     - `SearchScreen` (`EF8`) : recherche temps réel par ville/titre via `.where()`, filtres typologie/prix/pièces, compteur de résultats.
     - `ListingDetailScreen` (`EF1`, `EF2`, `EF5`) : fiche complète reçue via navigation, caution, commodités, bailleur vérifié, bouton favori et contact.
     - `PostListingScreen` (`EF3`, `EF4`, `RG-01`, `RG-02`, `RG-05`) : formulaire validé (titre >= 5 car., ville, loyer TND > 0, dropdown type, slider pièces 1–6, date picker, switch meublé, checkbox parking) renvoyant le nouveau `ListingEntity` via `pop` + `SnackBar`.

**Commits Phase 2 (7 commits) :**
- `feat(listings-domain): add ListingEntity, repository contract and usecases`
- `feat(listings-data): implement ListingModel and GitHub Raw REST datasource with offline asset fallback`
- `feat(listings-bloc): implement ListingsBloc and SwitchthemeBloc`
- `feat(ui-widgets): create ListingCard, CategoryFilterBar, AmenityBadge and CustomEmptyState`
- `feat(screens): implement HomeScreen and ListingDetailScreen with ListingEntity navigation`
- `feat(search): implement SearchScreen with real-time .where() filtering and category chips`
- `feat(post-listing): implement validated PostListingScreen form returning new listing via pop`

---

## Phase 3 — Feature `favorites` : État Partagé & Persistance `SharedPreferences` (Jalon J2 → J3)

1. **Data & Domain :** `FavoritesLocalDataSourceImpl` sauvegardant uniquement `List<String>` des `id` uniques (`RG-03`, `RG-04`) dans `SharedPreferences` (`EF7`).
2. **Presentation :** `SavedListingsBloc` + `SavedScreen` synchronisant l'icône cœur sur `ListingCard`, `ListingDetailScreen`, `SavedScreen` et le badge de la barre de navigation (`EF5`).

**Commits Phase 3 (3 commits) :**
- `feat(favorites-data): implement SharedPreferences local persistence for favorite listing IDs`
- `feat(favorites-bloc): implement SavedListingsBloc with startup hydration`
- `feat(saved-screen): implement SavedScreen and synchronize favorite toggles and nav badge`

---

## Phase 4 — Feature `auth` : Authentification Firebase & Profil Utilisateur

1. Implémenter `UserEntity`, `UserModel`, `UserDataSource`, `UserRepositoryImpl` et les 4 Use Cases (`register`, `sign_in`, `sign_out`, `update_user`).
2. Implémenter `AuthBloc` (avec événement interne sécurisé sur `userStream`) et `RegisterBloc`.
3. Implémenter `LoginScreen`, `RegisterScreen`, `ProfileScreen`, `LoginForm`, `RegisterForm`, `AuthButton`.

**Commits Phase 4 (3 commits) :**
- `feat(auth-domain-data): implement UserEntity, UserModel, Firebase datasource and repository`
- `feat(auth-bloc): implement AuthBloc and RegisterBloc with safe stream event dispatching`
- `feat(auth-ui): implement LoginScreen, RegisterScreen and ProfileScreen`

---

## Phase 5 — Tests, Documentation Académique & Build Release APK (Jalon J3 → Soutenance S9)

1. **Tests (`test/`) :** 4 tests unitaires/widgets (`ListingModel`, `SavedListingsBloc`, `ListingCard`, `PostListingForm`).
2. **Documentation :** Mise à jour `README.md` + `AI_JOURNAL.md`.
3. **Vérification & Livraison (`ENF3`, `ENF5`, `ENF7`) :** `flutter analyze`, `flutter test`, `flutter build apk --release`, `>= 20` commits Git.

**Commits Phase 5 (4 commits) :**
- `test(core): add unit and widget tests for ListingModel, SavedListingsBloc, ListingCard and PostListingForm`
- `docs(readme): write comprehensive README.md with official J0 project sheet and build instructions`
- `docs(ai-journal): create AI_JOURNAL.md documenting prompts, architecture choices and defense notes`
- `chore(release): verify flutter analyze, passing tests and release APK configuration`