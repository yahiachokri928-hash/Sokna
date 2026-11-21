# Journal de Bord IA (`AI_JOURNAL.md`) — Projet Sokna (سكنى)

**Étudiant :** Yahia Chokri (DSI 3 — ISET Bizerte)  
**Enseignante :** Mme Zouaghi Mounira  
**Cadre :** Atelier Cross-Platform (Projet de Synthèse 2026/2027)  
**Exigence :** ENF8 — Traçabilité exhaustive des interactions avec l'assistant IA, justification des arbitrages d'architecture et préparation de la soutenance individuelle (Semaine S9).

---

## 1. Vue d'Ensemble & Stratégie d'Assistance IA

L'ensemble du développement de l'application **Sokna (سكنى)** a été piloté en collaboration étroite avec l'assistant IA **Antigravity** (Google DeepMind), en suivant un cadre de gouvernance stricte formalisé dans `.agents/rules/sokna_architecture.md` et découpé en 5 phases successives selon `docs/execution_plan.md`.

Chaque phase a fait l'objet d'instructions précises, de vérifications statiques rigoureuses (`flutter analyze` sans le moindre warning) et de validations fonctionnelles conformes aux exigences académiques (`EF1` à `EF8`, `ENF1` à `ENF8` et `RG-01` à `RG-05`).

---

## 2. Chronologie des Phases de Réalisation & Prompts

### Phase 1 — Initialisation, Jeu de Données JSON & Socle `lib/core/` (Jalon J0 → J1)

- **Objectif :** Initialiser le projet Flutter sans toucher au dossier patrimonial `documents uni/`, structurer `pubspec.yaml` avec toutes les dépendances verrouillées, créer le dataset JSON de 16 logements tunisiens et implémenter la couche transverse `lib/core/`.
- **Prompt Utilisé :**
  > *"Execute Phase 1 completely for the Sokna project: Preserve `documents uni/` and `.gitattributes` completely untouched. Initialize the Flutter project in the root directory and configure `pubspec.yaml` with locked dependencies (`flutter_bloc`, `equatable`, `dartz`, `get_it`, `go_router`, `http`, `shared_preferences`, `internet_connection_checker`, `firebase_core`, `firebase_auth`, `validators`, `flutter_lints`), plus assets and Montserrat font. Create `assets/data/listings.json` with 16 realistic listings. Implement `lib/core/` (`di`, `exceptions`, `failures`, `firebase`, `network`, `router`, `strings`, `themes`, `utils`, `widgets`) and `main.dart`."*
- **Décisions d'Architecture Clés :**
  1. **Thématisation Material 3 Teal :** Configuration de `ColorManager.seedColorLight = Color(0xFF1A6B5A)` (Teal profond) et adaptation du contraste clair/sombre dans `ThemeManager`.
  2. **Zéro chaîne magique (`ENF1`) :** Isolation absolue des messages d'erreur et des libellés UI dans `lib/core/strings/failures.dart` et `messages.dart` sous forme de constantes `SCREAMING_SNAKE_CASE`.
  3. **Routage déclaratif `go_router` :** Utilisation d'un `ShellRoute` intégrant un `BottomNavigationBar` persistant sur les 4 onglets principaux (Accueil, Recherche, Favoris, Profil), avec injection des blocs globaux via `MultiBlocProvider`.

### Phase 2 — Feature `listings` : API REST Distante, Fallback Offline & Écrans Principaux (Jalon J1 → J2)

- **Objectif :** Développer le module de consultation, recherche multicritère et publication des biens locatifs en Clean Architecture pure.
- **Prompt Utilisé :**
  > *"Execute Phase 2 completely: Implement Domain Layer (`ListingEntity`, `ListingRepository`, 3 usecases), Data Layer (`ListingModel`, `ListingDataSource` consuming GitHub Raw with fallback to `rootBundle`, `ListingRepositoryImpl`), BLoCs (`ListingsBloc`, `SwitchthemeBloc`), Atomic widgets (`ListingCard`, `CategoryFilterBar`, `AmenityBadge`, `CustomEmptyState`, `PostListingForm`), and Screens (`HomeScreen`, `SearchScreen`, `ListingDetailScreen`, `PostListingScreen`)."*
- **Décisions d'Architecture Clés :**
  1. **Résilience Réseau Maximale (`EF6` & `ENF3`) :** `ListingDataSourceImpl` tente d'abord de récupérer le JSON distant sur GitHub Raw via `http.get`. En cas de panne réseau, de code HTTP non-200 ou d'exception, il bascule automatiquement et instantanément sur le fichier local embarqué `assets/data/listings.json` via `rootBundle.loadString`. L'application ne plante jamais hors-ligne.
  2. **Recherche Réactive en Mémoire (`EF8`) :** `SearchScreen` écoute en direct le champ texte et applique une combinaison de prédicats Dart `.where()` combinant la sous-chaîne de la ville ou du titre, la catégorie sélectionnée, le plafond budgétaire et le nombre minimum de pièces.
  3. **Contrat de Formulaire Strict (`EF3`, `RG-01`, `RG-02`, `RG-05`) :** `PostListingForm` intègre plus de 5 types de saisie différents (`TextFormField`, `DropdownButtonFormField`, `Slider`, `showDatePicker`, `SwitchListTile`, `CheckboxListTile`) avec validation stricte avant construction de l'entité `ListingEntity` et retour via `Navigator.pop`.

### Phase 3 — Feature `favorites` : État Partagé Réactif & Persistance `SharedPreferences` (Jalon J2 → J3)

- **Objectif :** Implémenter la persistance locale des favoris et synchroniser l'état réactif sur toute l'interface.
- **Prompt Utilisé :**
  > *"Execute Phase 3 completely: Implement Domain (`FavoritesRepository`, `GetSavedListingIdsUseCase`, `ToggleSavedListingUseCase`), Data (`FavoritesLocalDataSource` storing only `List<String>` unique IDs in `SharedPreferences`, `FavoritesRepositoryImpl`), and `SavedListingsBloc`. Synchronize favorite toggles across ListingCard, ListingDetailScreen, SavedScreen, and bottom navigation badge."*
- **Décisions d'Architecture Clés :**
  1. **Stockage Léger & Anti-Désynchronisation (`RG-03`, `RG-04`, `EF7`) :** Seuls les identifiants textuels uniques (`List<String>` de `listingId`) sont enregistrés dans `SharedPreferences` sous la clé `saved_listing_ids`. Cela garantit que la mise à jour d'un prix ou d'une description sur l'API distante se répercute automatiquement sur les annonces sauvegardées sans duplication ni incohérence.
  2. **Quadruple Synchronisation (`EF5`) :** L'action d'ajout/retrait d'un favori se reflète simultanément et sans rechargement sur :
     - La carte de l'annonce (`ListingCard` - icône cœur remplie/vide)
     - La page de détail (`ListingDetailScreen` - bouton flottant d'action)
     - L'écran dédié aux favoris (`SavedScreen` - rafraîchissement immédiat de la liste ou de l'état vide)
     - Le badge numérique de la barre de navigation inférieure (`ShellRoute` via `BlocBuilder<SavedListingsBloc, SavedListingsState>`).

### Phase 4 — Feature `auth` : Authentification Firebase & Sécurité des Streams BLoC

- **Objectif :** Intégrer l'authentification Firebase, la gestion du profil utilisateur et sécuriser le flux d'écoute de l'utilisateur.
- **Prompt Utilisé :**
  > *"Execute Phase 4 completely: Implement UserEntity, UserModel, UserDataSource, UserRepositoryImpl mapping FirebaseAuthExceptions to typed Failures, modern AuthBloc dispatching internal AuthUserChangedEvent (never calling emit() directly in stream .listen()), RegisterBloc, LoginScreen, RegisterScreen, ProfileScreen and custom auth widgets."*
- **Décisions d'Architecture Clés :**
  1. **Sécurité BLoC 9.x Stream-Safe :** Dans `AuthBloc`, l'abonnement à `authService.userStream` n'appelle jamais directement `emit()`. Il dispatche un événement interne `_AuthUserChangedEvent(user)` traité par un gestionnaire `on<_AuthUserChangedEvent>`, éliminant tout risque de fuite de mémoire ou d'émission hors cycle de vie.
  2. **Tolérance Hors-Ligne & Environnement Sans Clés :** Dans les cas où Firebase n'est pas configuré avec des clés réelles ou en mode déconnecté, `AuthService` intercepte gracieusement les exceptions et l'application demeure utilisable en mode invité.

### Phase 5 — Tests Automatisés, Documentation Finale & Release APK (Jalon J3 → Soutenance S9)

- **Objectif :** Écrire une suite de tests unitaires et de widgets ciblés, rédiger la documentation finale (`README.md`, `AI_JOURNAL.md`), vérifier le code et compiler l'APK Release.
- **Prompt Utilisé :**
  > *"Execute Phase 5 completely: Add 4 test files in test/ (listing_model_test, saved_listings_bloc_test, listing_card_test, post_listing_form_test). Finalize README.md and AI_JOURNAL.md in French. Run flutter analyze, flutter test, and flutter build apk --release. Create the 4 phase 5 git commits."*
- **Résultats Obtenus :**
  - `flutter analyze` : 0 erreur, 0 avertissement.
  - `flutter test` : 10 tests réussis sur 10.
  - Historique Git : Plus de 20 commits conventionnels conformes aux standards professionnels.

---

## 3. Guide de Révision pour la Soutenance Individuelle (Semaine S9)

Cette section synthétise les réponses types aux questions récurrentes du jury d'examen à l'ISET Bizerte.

### Q1 : Pourquoi avoir choisi la Clean Architecture plutôt qu'une structure MVC classique ?
> **Réponse :** La Clean Architecture isole strictement les règles métier pures (`domain/`) de toute dépendance technologique externe (`flutter`, `http`, `firebase`). Si demain nous remplaçons le package `http` par `dio`, ou `shared_preferences` par `hive`, aucune ligne de code dans nos entités ou nos Use Cases n'est impactée. Cela permet également de tester unitairement 100% de la logique métier sans avoir à instancier un environnement graphique Flutter.

### Q2 : Quelle est la différence entre `ListingModel` et `ListingEntity` ?
> **Réponse :** 
> - `ListingEntity` (couche **Domain**) est une classe immuable pure Dart étendant `Equatable`. Elle ne contient aucune logique de sérialisation JSON.
> - `ListingModel` (couche **Data**) hérite de `ListingEntity` et ajoute les méthodes techniques `fromJson()`, `toJson()` et `fromEntity()`. La couche présentation ne manipule que des `ListingEntity`, respectant le principe d'inversion des dépendances.

### Q3 : Pourquoi utiliser `Either<Failure, T>` de la bibliothèque `dartz` ?
> **Réponse :** Le type fonctionnel `Either` remplace les blocs `try/catch` imprévisibles dans l'interface graphique. Une fonction retourne explicitement soit un échec à gauche (`Left(Failure)`), soit un succès à droite (`Right(T)`). Dans le BLoC, l'appel à `.fold(...)` oblige le développeur à traiter de façon exhaustive le cas d'erreur (en émettant un `State` d'erreur) et le cas de succès, rendant le code totalement sûr contre les exceptions non gérées.

### Q4 : Comment fonctionne la synchronisation des favoris sans base de données centrale ?
> **Réponse :** Grâce au pattern BLoC (`SavedListingsBloc`) fourni au sommet de l'arbre des widgets (`main.dart` via `BlocProvider`). Lorsque l'utilisateur clique sur le cœur d'une `ListingCard` ou de `ListingDetailScreen`, l'événement `ToggleSavedListingEvent` est émis. Le BLoC modifie sa liste en mémoire, sauvegarde la liste des IDs dans `SharedPreferences` et émet un nouvel état `SavedListingsLoaded`. Tous les widgets abonnés (`BlocBuilder`) se reconstruisent instantanément en réagissant à ce nouvel état.

### Q5 : Pourquoi stocker uniquement les IDs dans `SharedPreferences` plutôt que les annonces entières ?
> **Réponse :** Pour deux raisons cruciales (`RG-04`) :
> 1. **Économie de mémoire :** Une liste de chaînes de caractères (`List<String>`) occupe quelques octets contre plusieurs dizaines de kilo-octets pour des objets JSON complets.
> 2. **Cohérence des données :** Si le propriétaire modifie le loyer d'un appartement de 800 TND à 750 TND sur l'API, l'utilisateur retrouvera le nouveau prix actualisé dans ses favoris, car `SavedScreen` croise les identifiants persistés avec les entités à jour issues de `ListingsBloc`.

### Q6 : Comment est assurée la résilience hors-ligne de l'application ?
> **Réponse :** Dans `ListingDataSourceImpl`, nous implémentons un mécanisme de repli transparent (*graceful degradation*). Si la requête HTTP vers GitHub Raw échoue (absence de réseau, serveur inaccessible), le code intercepte l'erreur et charge immédiatement le fichier `assets/data/listings.json` via `rootBundle.loadString()`. L'utilisateur dispose ainsi toujours d'un catalogue complet fonctionnel.
