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

### Phases F1 à F4 — Extension Cloud Firebase & Firestore (`firebase-cloud`)

Pour aller au-delà des exigences minimales et doter l'application d'un backend serverless de niveau industriel, quatre phases additionnelles ont été exécutées :

1. **Phase F1 (Socle Cloud & Règles de Sécurité) :**
   - Ajout de `cloud_firestore: ^7.2.0` et élévation de `minSdk = 23` dans `android/app/build.gradle.kts`.
   - Création du service d'infrastructure `FirestoreService` encapsulant `FirebaseFirestore.instance` et injecté dans `lib/core/di/service_locator.dart`.
   - Rédaction des règles de sécurité `firestore.rules` verrouillant les collections `users/{userId}` et `listings/{listingId}`.
   - Durcissement de `.agents/rules/sokna_architecture.md` (interdiction stricte de `cloud_firestore` en dehors de `core/firebase/` et `features/*/data/`).

2. **Phase F2 (Profils Utilisateurs Cloud Firestore) :**
   - Extension de `UserEntity` et `UserModel` avec `phone`, `role` (`Locataire` / `Propriétaire`), `createdAt`, `fromFirestore` et `toFirestore`.
   - Implémentation de `GetCurrentUserProfileUseCase` et synchronisation bidirectionnelle dans `UserDataSourceImpl` (création du document Firestore à l'inscription, vérification à la connexion, mise à jour synchrone).
   - Ajout d'une feuille modale de modification de profil (`_showEditProfileModal`) dans `ProfileScreen` dispatchant `UpdateUserProfileEvent`.

3. **Phase F3 (Favoris Cloud par Utilisateur & Cache Hybride) :**
   - Création de `FavoritesRemoteDataSource` gérant les opérations atomiques `FieldValue.arrayUnion` et `FieldValue.arrayRemove` sur `users/{uid}.savedListingIds`.
   - Réalisation de `FavoritesRepositoryImpl` hybride : synchronisation Cloud prioritaire quand connecté et en ligne, avec miroir synchrone dans `SharedPreferences` (`FavoritesLocalDataSource`) et repli gracieux hors-ligne (`EF7`, `ENF3`).
   - Ajout d'un `BlocListener<AuthBloc, AuthState>` global dans `main.dart` déclenchant automatiquement `LoadSavedListingsEvent` lors de toute transition d'authentification (`EF5`).

4. **Phase F4 (Annonces Cloud, Gestion Propriétaire & Release APK) :**
   - Ajout de `ownerId` à `ListingEntity` et `ListingModel` (`fromFirestore`, `toFirestore`).
   - Création de `DeleteListingUseCase` et intégration de la suppression dans `ListingsBloc` (`DeleteListingEvent`).
   - Fusion transparente dans `ListingDataSourceImpl` du catalogue REST GitHub Raw / asset local et des annonces Firestore en temps réel.
   - Protection de `PostListingScreen` (accès réservé aux utilisateurs authentifiés avec rattachement automatique de `ownerId`).
   - Section **« Mes annonces publiées »** dans `ProfileScreen` permettant la consultation et la suppression unitaire avec dialogue de confirmation.
   - Suite de tests portée à 18 tests automatisés réussis et compilation de l'APK Release.

---

### Phases C1 à C4 — Catalogue 100% Cloud Firestore, Avis Locataires & Seeder Démo Tunisien

Afin de transformer Sokna en une véritable application de production multi-utilisateurs temps réel pour le marché tunisien, les phases C1 à C4 ont été réalisées :

1. **Phase C1 (Catalogue 100% Cloud Firestore & Métadonnées Bailleurs) :**
   - Transition de `ListingDataSourceImpl` vers une lecture **exclusivement Cloud Firestore** (`listingsCollection.orderBy('createdAt', descending: true)`).
   - Mise en cache locale des annonces Cloud dans `SharedPreferences` (`CACHED_CLOUD_LISTINGS`) garantissant un fonctionnement fluide hors-ligne (`ENF3`).
   - Extension de `ListingEntity` et `ListingModel` avec `ownerPhone` et `ownerAvatarUrl`.
   - Carte bailleur enrichie sur `ListingDetailScreen` avec photo de profil / initiale, badge vérifié, et actions d'appel / SMS.
   - Ajustement des règles `firestore.rules` autorisant la mise à jour des champs `rating` et `reviewCount`.

2. **Phase C2 (Avis & Notations Locataires dans Firestore) :**
   - Création de la sous-collection `listings/{listingId}/reviews/{userId}`.
   - Entité `ReviewEntity` (Pure Dart) et modèle `ReviewModel` (`fromFirestore`, `toFirestore`, `fromJson`, `toJson`).
   - Use Cases `GetListingReviewsUseCase` et `SubmitReviewUseCase` injectés dans `service_locator.dart`.
   - Création de `ReviewsBloc` (`part`/`part of`) gérant `LoadReviewsEvent` et `SubmitReviewEvent`.
   - Composant interactif sur `ListingDetailScreen` : sélecteur de note 1 à 5 étoiles, champ commentaire, contrôle de connexion et recalcul dynamique de la note moyenne et du nombre d'avis sur le document d'annonce.

3. **Phase C3 (Seeder Cloud Tunisien Idempotent & Sélecteur Démo 1-Clic) :**
   - Création de `FirestoreCloudSeeder` (`lib/core/firebase/firestore_cloud_seeder.dart`) avec 10 comptes tunisiens réalistes (mot de passe universel `Sokna2026!`) :
     - 6 Bailleurs : Amine Ben Ali (Bizerte), Salma Trabelsi (La Marsa), Youssef Gharbi (Hammamet), Ons Mansouri (Sousse), Mehdi Bouazizi (Tunis Lac 2), Nourhene Khelifi (Monastir).
     - 4 Locataires : Aziz Chaabane (Étudiant ISET Bizerte), Meriem Jaziri (Tunis), Bilel Hammami (Sousse), Ines Dridi (Sfax).
   - Intégration de 16 annonces tunisiennes authentiques réparties sur 10 villes et 36 avis locataires réalistes.
   - Auto-seed transparent au démarrage dans `main.dart` si Firestore est vide.
   - Carte rétractable **« Comptes Démo Tunisiens (Connexion 1-clic) »** et bouton **« Peupler / Réinitialiser la base Cloud »** sur `ProfileScreen`.

4. **Phase C4 (Consolidation des Tests, Documentation & Release APK) :**
   - Suite de tests portée à 28 tests automatisés (couvrant modèles, use cases, BLoCs, widgets et seeder).
   - Documentation complète dans `README.md` et `AI_JOURNAL.md`.
   - Compilation de l'APK Release optimisé pour la soutenance.

---

### Phases G1 à G4 — Flux Invité Sécurisé, Portes d'Accès & Démo APK (`firebase-cloud`)

Pour préparer la mise en production et garantir une expérience utilisateur parfaite lors des tests d'évaluation par le jury, quatre phases d'affinement « Guest-First » ont été menées :

1. **Phase G1 (Suppression de l'Auto-Seeding & Données Utilisateurs Cloud Pures) :**
   - Suppression définitive de l'auto-seed au démarrage dans `main.dart` pour éviter toute écriture concurrente ou réinitialisation intempestive en production.
   - Suppression du bouton de réinitialisation/seeding de la base depuis l'écran de profil.
   - Verrouillage des favoris en mode invité : `getSavedListingIds()` renvoie `[]` et `toggleSavedListing()` renvoie `Left(AuthFailure)` sans écriture locale parasite.
2. **Phase G2 (Portes d'Accès Invités - *Guest Gates*) :**
   - Création du composant Material 3 réutilisable `GuestAuthPrompt` (`lib/core/widgets/guest_auth_prompt.dart`) en modes complet et compact.
   - Verrouillage élégant du bouton favori sur `ListingCard` et `ListingDetailScreen` (avec SnackBar d'action « Se connecter »).
   - Verrouillage de la publication sur `PostListingScreen` et de la notation locataire sur `ListingDetailScreen` avec affichage de `GuestAuthPrompt`.
3. **Phase G3 (Écran Profil Invité & Connexion Démo 1-Clic APK) :**
   - Refonte complète de `ProfileScreen` en mode invité : carte « Mode Invité », checklist des fonctionnalités réservées aux membres, boutons pleine largeur « Se connecter » et « Créer un compte », bascule de thème clair/sombre.
   - Carte « Comptes de test Tunisiens (Démo APK) » listant les 10 comptes tunisiens réalistes (`demoAccounts`) avec connexion instantanée en 1 tap pour tester les rôles Propriétaire et Locataire sans saisie manuelle.
4. **Phase G4 (Consolidation des Tests, Documentation & APK Invité/Cloud) :**
   - Suite de tests portée à **36 tests automatisés** réussis avec 0 avertissement `flutter analyze`.
   - Documentation exhaustive et compilation de l'APK Release final.

### Phase 7 — Polissage UI/UX, Médias Spark-Free & Upload d'Avatars (Phases U1 → U3)

1. **Phase U1 (Salutation Dynamique, Logo Maison & SnackBar Invité) :**
   - Suppression du nom en dur "Yahia" sur `HomeScreen` au profit d'un `BlocBuilder<AuthBloc>` affichant dynamiquement `Bonjour, <Nom>` avec badge de rôle, ou `Bienvenue sur Sokna` en mode invité.
   - Création du widget de marque unifié `SoknaLogo` avec emblème maison stylisé, bilingue (« Sokna » / « سكنى »).
   - Helper `showGuestAuthSnackBar` auto-nettoyant avec redirection propre vers `/login`.
2. **Phase U2 (Galerie Multi-Photos & Stockage Spark-Free dans Firestore) :**
   - Implémentation de `ImageEncodingHelper` encodant les images (max 800x600, q:65) en Base64 JPEG compact (~180 Ko max par photo) permettant de stocker jusqu'à 4 photos par annonce directement dans le document Firestore, sans dépendance au plan payant Blaze (Firebase Storage).
   - Création de `SmartNetworkImage` décodant automatiquement les Data URIs en mémoire (`Image.memory`) et les URLs web (`Image.network`), avec fallback placeholder élégant.
   - Sélection multi-photos dans `PostListingForm` via Galerie et Caméra avec prévisualisation en bande défilante et suppression unitaire.
   - Carrousel tactile swipeable `PageView.builder` sur `ListingDetailScreen` avec badge compteur (`1 / 4`) et points indicateurs animés.
3. **Phase U3 (Upload d'Avatar Caméra/Galerie & Enrichissement du Seeder Cloud) :**
   - Badge d'édition caméra sur l'avatar du profil ouvrant une feuille modale Material 3 avec options **« Prendre une photo »** et **« Choisir depuis la galerie »**.
   - `UpdateAvatarUseCase` encodant l'image en JPEG compact (320x320, ~20 Ko) et mettant à jour `users/{uid}.profilURL` dans Firestore.
   - Prise en charge universelle des avatars Base64 et HTTP via `ImageEncodingHelper.getAvatarImageProvider` sur `ProfileScreen` et `ListingDetailScreen`.
   - Enrichissement des 16 annonces tunisiennes du seeder avec 4 photos chacune (salon, chambre, cuisine, vue/extérieur).

---

## 3. Guide de Révision pour la Soutenance Individuelle (Semaine S9)

Cette section synthétise les réponses types aux questions récurrentes du jury d'examen à l'ISET Bizerte.

### Q1 : Pourquoi avoir choisi la Clean Architecture plutôt qu'une structure MVC classique ?
> **Réponse :** La Clean Architecture isole strictement les règles métier pures (`domain/`) de toute dépendance technologique externe (`flutter`, `http`, `firebase`). Si demain nous remplaçons le package `http` par `dio`, ou `shared_preferences` par `hive`, aucune ligne de code dans nos entités ou nos Use Cases n'est impactée. Cela permet également de tester unitairement 100% de la logique métier sans avoir à instancier un environnement graphique Flutter.

### Q2 : Quelle est la différence entre `ListingModel` et `ListingEntity` ?
> **Réponse :** 
> - `ListingEntity` (couche **Domain**) est une classe immuable pure Dart étendant `Equatable`. Elle ne contient aucune logique de sérialisation JSON.
> - `ListingModel` (couche **Data**) hérite de `ListingEntity` et ajoute les méthodes techniques `fromJson()`, `toJson()`, `fromFirestore()` et `toFirestore()`. La couche présentation ne manipule que des `ListingEntity`, respectant le principe d'inversion des dépendances.

### Q3 : Pourquoi utiliser `Either<Failure, T>` de la bibliothèque `dartz` ?
> **Réponse :** Le type fonctionnel `Either` remplace les blocs `try/catch` imprévisibles dans l'interface graphique. Une fonction retourne explicitement soit un échec à gauche (`Left(Failure)`), soit un succès à droite (`Right(T)`). Dans le BLoC, l'appel à `.fold(...)` oblige le développeur à traiter de façon exhaustive le cas d'erreur (en émettant un `State` d'erreur) et le cas de succès, rendant le code totalement sûr contre les exceptions non gérées.

### Q4 : Comment fonctionne la synchronisation des favoris dans la version Cloud ?
> **Réponse :** Dans la version Cloud (`firebase-cloud`), la gestion des favoris suit une politique stricte *Cloud-First & Guest-Gated* :
> - En mode invité, les favoris sont verrouillés avec invitation immédiate à la connexion (`GuestAuthPrompt` et SnackBar d'action), sans écriture locale parasite.
> - Dès l'authentification (`authService.currentUser != null`), les identifiants sont synchronisés en direct sur Cloud Firestore (`users/{uid}.savedListingIds`) avec des opérateurs atomiques (`arrayUnion`/`arrayRemove`) et immédiatement mis en miroir dans `SharedPreferences` pour garantir une consultation hors-ligne fluide (`ENF3`).

### Q5 : Pourquoi stocker uniquement les IDs dans `SharedPreferences` plutôt que les annonces entières ?
> **Réponse :** Pour deux raisons cruciales (`RG-04`) :
> 1. **Économie de mémoire :** Une liste de chaînes de caractères (`List<String>`) occupe quelques octets contre plusieurs dizaines de kilo-octets pour des objets JSON complets.
> 2. **Cohérence des données :** Si le propriétaire modifie le loyer d'un appartement de 800 TND à 750 TND sur l'API ou Firestore, l'utilisateur retrouvera le nouveau prix actualisé dans ses favoris, car `SavedScreen` croise les identifiants persistés avec les entités à jour issues de `ListingsBloc`.

### Q6 : Comment est assurée la résilience hors-ligne de l'application ?
> **Réponse :** Dans `ListingDataSourceImpl`, nous implémentons un mécanisme de repli transparent (*graceful degradation*). Si la requête HTTP vers GitHub Raw échoue (absence de réseau, serveur inaccessible), le code intercepte l'erreur et charge immédiatement le fichier `assets/data/listings.json` via `rootBundle.loadString()`. De même, les échecs Firestore sont interceptés et l'application demeure 100% opérationnelle en lecture locale.

### Q7 : Comment les règles de sécurité Firestore garantissent-elles l'intégrité des données ?
> **Réponse :** Dans `firestore.rules`, nous appliquons le principe du moindre privilège :
> 1. `users/{userId}` : accessible en lecture et écriture uniquement si `request.auth.uid == userId`.
> 2. `listings/{listingId}` : accessible en lecture par tout le monde (`allow read: if true`), mais modifiable/supprimable uniquement par le créateur de l'annonce (`resource.data.ownerId == request.auth.uid`).

### Q8 : Que se passe-t-il quand un utilisateur change de session (connexion / déconnexion) ?
> **Réponse :** Dans `main.dart`, le widget racine écoute les transitions de `AuthBloc` via `BlocListener<AuthBloc, AuthState>`. Dès qu'un état `AuthenticatedState` ou `UnAuthenticatedState` est émis, un événement `LoadSavedListingsEvent` est immédiatement dépêché à `SavedListingsBloc`. L'interface recharge instantanément la liste des favoris propre au compte connecté (ou du profil invité) sans redémarrage de l'application.

### Q9 : Comment fonctionne le stockage multi-photos et d'avatar sans Firebase Storage (Spark Plan) ?
> **Réponse :** Le plan gratuit Firebase Spark n'inclut pas de bucket Cloud Storage sans carte bancaire (Blaze). Pour garantir que l'application reste 100% fonctionnelle, autonome et gratuite :
> 1. Les photos sélectionnées (galerie ou caméra via `image_picker`) sont redimensionnées et compressées via `ImageEncodingHelper` en Data URIs JPEG Base64 (`data:image/jpeg;base64,...`).
> 2. Une photo d'annonce compressée (800x600, q:65) pèse entre 40 et 80 Ko, et un avatar (320x320, q:70) pèse ~20 Ko. Ainsi, 4 photos d'annonce totalisent ~250 Ko, restant largement en dessous du plafond strict de 1 Mo par document Cloud Firestore.
> 3. Le widget `SmartNetworkImage` et le helper `getAvatarImageProvider` détectent automatiquement le préfixe `data:image` pour décoder et afficher l'image directement depuis la mémoire (`Image.memory` / `MemoryImage`), tout en supportant les URLs HTTP standards (`NetworkImage`).
