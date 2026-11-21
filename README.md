# Sokna (سكنى) — Application Mobile de Location Immobilière en Tunisie

[![Flutter](https://img.shields.io/badge/Flutter-3.47.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.2-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20BLoC-1A6B5A)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-Academic-blue.svg)](LICENSE)

Application mobile multiplateforme développée avec **Flutter** et **Dart** dans le cadre de l'**Atelier Cross-Platform (DSI 3 — 2026/2027)** à l'**Institut Supérieur des Études Technologiques de Bizerte (ISET Bizerte)**, sous l'encadrement de **Mme Zouaghi Mounira**.

- **Étudiant :** Yahia Chokri (DSI 3)
- **Dépôt officiel GitHub :** [https://github.com/yahiachokri928-hash/Sokna](https://github.com/yahiachokri928-hash/Sokna)
- **API REST Distante (GitHub Raw) :** [https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json](https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json)

---

## 1. Contexte & Problématique Métier

En Tunisie, la recherche d'un logement locatif (studios pour étudiants, appartements pour jeunes couples ou villas familiales) est fréquemment ralentie par des annonces dispersées sur les réseaux sociaux, des informations de loyer imprécises et des intermédiaires informels (« samsar ») appliquant des commissions opaques.

**Sokna (سكنى)** répond directement à cette problématique en offrant une plateforme mobile unifiée, rapide, ergonomique et résiliente :
1. **Transparence totale des loyers en Dinars Tunisiens (TND)** avec détail des charges et caution.
2. **Recherche multicritère instantanée** (ville, typologie, budget maximal, nombre de pièces S+X, meublé, parking).
3. **Gestion réactive des favoris** synchronisée en temps réel et persistée localement hors ligne.
4. **Publication sécurisée d'annonces de location** avec contrôle strict de validation des formulaires.
5. **Résilience réseau maximale** grâce à une double stratégie : API REST distante GitHub Raw couplée à un secours local instantané (`assets/data/listings.json`) garantissant un fonctionnement fluide même sans connexion Internet.

---

## 2. Fiche Projet Officielle (Jalon J0)

| Rubrique | Spécification Officielle Validée |
| :--- | :--- |
| **Nom de l'application** | **Sokna (سكنى)** |
| **Membres du binôme** | **Yahia Chokri** (Travail individuel / Solo — DSI 3 ISET Bizerte) |
| **Lien du dépôt GitHub** | [https://github.com/yahiachokri928-hash/Sokna](https://github.com/yahiachokri928-hash/Sokna) |
| **Le besoin, en une phrase** | Permettre aux locataires en Tunisie de rechercher, filtrer et sauvegarder des annonces de logements claires et géolocalisées, et aux propriétaires de publier et gérer leurs offres de location en toute simplicité. |
| **Liste des écrans (min. 4)** | 1. **Accueil (`HomeScreen`)** : Bannière de salutation, carrousel de catégories, sélection de logements vérifiés.<br>2. **Recherche & Filtres (`SearchScreen`)** : Barre de recherche instantanée par ville/titre, chips de catégories, filtres budget et pièces, liste filtrée en temps réel.<br>3. **Détail du Logement (`ListingDetailScreen`)** : Galerie photo, caractéristiques (S+X, surface m², meublé, parking), loyer mensuel en TND, coordonnées du bailleur, bascule favori et bouton contact.<br>4. **Favoris (`SavedScreen`)** : Liste des annonces sauvegardées, synchronisation instantanée avec le badge de navigation, suppression unitaire et état vide personnalisé.<br>5. **Publication d'annonce (`PostListingScreen`)** : Formulaire complet avec validation stricte renvoyant le nouveau bien ajouté.<br>*(+ Authentification & Profil : `LoginScreen`, `RegisterScreen`, `ProfileScreen`)* |
| **Le formulaire (EF3) : champs** | - Titre de l'annonce (`TextFormField`, >= 5 caractères)<br>- Ville (`TextFormField`, obligatoire)<br>- Adresse complète (`TextFormField`, obligatoire)<br>- Type de bien (`DropdownButtonFormField` : Studio, Appartement, Villa, Maison)<br>- Loyer mensuel en TND (`TextFormField` numérique > 0)<br>- Nombre de pièces (`Slider` 1 à 6 pièces / S+X)<br>- Surface en m² (`TextFormField` numérique > 0)<br>- Date de disponibilité (`showDatePicker`, sélecteur de calendrier)<br>- Meublé (`SwitchListTile`)<br>- Parking privé inclus (`CheckboxListTile`)<br>- Nom du bailleur / Propriétaire (`TextFormField`, obligatoire)<br>- Description détaillée (`TextFormField` multiligne, obligatoire) |
| **L'état partagé (EF5)** | État réactif des annonces favorites géré par `SavedListingsBloc` et synchronisé simultanément sur 4 emplacements de l'application :<br>1. Le bouton cœur interactif sur chaque carte `ListingCard`<br>2. Le bouton flottant cœur de la fiche `ListingDetailScreen`<br>3. La liste dédiée sur l'écran `SavedScreen`<br>4. Le badge numérique rouge sur l'onglet « Favoris » de la barre de navigation inférieure (`ShellRoute`). |
| **L'API (EF6) : nom et lien** | **API REST JSON Sokna** hébergée sur GitHub Raw (16 logements tunisiens réalistes avec 16 attributs stricts), consommée via le package `http` avec repli hors ligne automatique sur `rootBundle.loadString('assets/data/listings.json')` :<br>[https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json](https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json) |
| **La donnée persistée (EF7)** | La liste des identifiants uniques (`List<String>` de `listingId`) des annonces sauvegardées en favoris, persistée localement et de manière synchrone dans `SharedPreferences` (`saved_listing_ids`). Aucune donnée sensible ou objet volumineux n'est sérialisé (`RG-04`). |
| **Bonus envisagé** | 1. **Mode sombre dynamique (Dark Theme Material 3)** commutable à tout moment via `SwitchthemeBloc` et persistant.<br>2. **Suite de tests automatisés** unitaires (`ListingModel`, `SavedListingsBloc`) et de widgets (`ListingCard`, `PostListingForm`).<br>3. **Gestion complète de l'authentification Firebase** (Connexion, Inscription, Profil utilisateur, Déconnexion). |
| **Répartition du travail** | Réalisation individuelle intégrale par Yahia Chokri : conception, architecture Clean Architecture + BLoC, développement Flutter, tests unitaires/widgets et documentation. |

---

## 3. Matrice de Traçabilité des Exigences (EF & ENF)

### 3.1. Exigences Fonctionnelles (EF1 à EF8)

| Code | Exigence Fonctionnelle | Fichiers d'Implémentation Clés | Statut |
| :--- | :--- | :--- | :---: |
| **EF1** | Consultation de la liste des logements et fiche détaillée | `lib/features/listings/presentation/screens/home_screen.dart`<br>`lib/features/listings/presentation/screens/listing_detail_screen.dart` | Validé |
| **EF2** | Navigation fluide par passage d'entité `ListingEntity` | `lib/core/router/app_router.dart`<br>`lib/features/listings/presentation/widgets/listing_card.dart` | Validé |
| **EF3** | Formulaire de saisie d'annonce avec >= 5 types de champs | `lib/features/listings/presentation/widgets/post_listing_form.dart`<br>`lib/features/listings/presentation/screens/post_listing_screen.dart` | Validé |
| **EF4** | Ajout de bien dans la liste courante avec retour utilisateur | `lib/features/listings/presentation/blocs/listings/listings_bloc.dart`<br>`lib/core/utils/snack_bar_message.dart` | Validé |
| **EF5** | Gestion d'état réactive partagée (Favoris synchronisés) | `lib/features/favorites/presentation/blocs/saved_listings/saved_listings_bloc.dart`<br>`lib/core/router/app_router.dart` (Badge) | Validé |
| **EF6** | Consommation d'une API REST distante avec repli hors-ligne | `lib/features/listings/data/datasources/listing_data_source.dart`<br>`assets/data/listings.json` | Validé |
| **EF7** | Persistance locale des données (Favoris sauvegardés) | `lib/features/favorites/data/datasources/favorites_local_data_source.dart` (`SharedPreferences`) | Validé |
| **EF8** | Recherche et filtrage multicritère temps réel | `lib/features/listings/presentation/screens/search_screen.dart`<br>`lib/features/listings/presentation/blocs/listings/listings_bloc.dart` | Validé |

### 3.2. Exigences Non-Fonctionnelles (ENF1 à ENF8)

| Code | Exigence Non-Fonctionnelle | Justification & Implémentation | Statut |
| :--- | :--- | :--- | :---: |
| **ENF1** | Zéro chaîne magique en dur (Centralisation des textes) | Constantes françaises SCREAMING_SNAKE_CASE dans `lib/core/strings/messages.dart` et `failures.dart`. | Validé |
| **ENF2** | Identité visuelle Material 3 & Typographie soignée | `ColorManager.seedColorLight` (`#1A6B5A` Deep Teal), `Montserrat` pour tous les textes, cibles tactiles >= 48x48 dp. | Validé |
| **ENF3** | Robustesse offline & Zéro crash en cas de coupure | `ListingDataSourceImpl` bascule sur `rootBundle` si réseau indisponible. `NetworkInfo` vérifie la connectivité. | Validé |
| **ENF4** | Modularité stricte (Un widget réutilisable par fichier) | Dossier `widgets/` atomisé : `listing_card.dart`, `category_filter_bar.dart`, `amenity_badge.dart`, etc. | Validé |
| **ENF5** | Qualité de code exemplaire (`flutter analyze` 0 avertissement) | Aucune règle linter enfreinte, typage strict Dart 3, respect des couches Clean Architecture. | Validé |
| **ENF6** | Documentation complète du projet | `README.md` exhaustif avec fiche J0, commandes CLI, matrice et guide de soutenance. | Validé |
| **ENF7** | Historique Git rigoureux (>= 20 commits conventionnels) | Plus de 20 commits suivant la convention Conventional Commits (`feat`, `chore`, `test`, `docs`). | Validé |
| **ENF8** | Traçabilité des prompts et décisions IA | `AI_JOURNAL.md` détaillant les phases 1 à 5, les arbitrages d'architecture et les réponses pour la soutenance. | Validé |

---

## 4. Architecture du Projet (`lib/`)

Le projet applique rigoureusement les principes de la **Clean Architecture** associée au pattern **BLoC** (`flutter_bloc 9.0.0`) :

```text
lib/
├── firebase_options.dart
├── main.dart                               # Initialisation DI, Firebase, Blocs globaux
├── core/                                   # Socle technique transverse partagé
│   ├── di/
│   │   └── service_locator.dart            # Injection de dépendances via GetIt
│   ├── exceptions/
│   │   └── exceptions.dart                 # ServerException, EmptyCacheException, OfflineException
│   ├── failures/
│   │   ├── failures.dart                   # ServerFailure, EmptyCacheFailure, OfflineFailure
│   │   ├── auth_failures.dart              # Typed Auth Failures
│   │   └── listing_failures.dart           # ListingSpecificFailures
│   ├── firebase/
│   │   └── auth_service.dart               # Wrapper sécurisé FirebaseAuth
│   ├── network/
│   │   └── network_info.dart               # Détection de connectivité via InternetConnectionChecker
│   ├── router/
│   │   ├── app_router.dart                 # Configuration GoRouter, ShellRoute & Navigation Badge
│   │   └── routes.dart                     # Constantes de nommage des routes
│   ├── strings/
│   │   ├── failures.dart                   # Messages d'erreurs constants
│   │   └── messages.dart                   # Libellés UI et messages de validation constants
│   ├── themes/
│   │   ├── color_manager.dart              # Palette de couleurs Teal (#1A6B5A)
│   │   └── font_manager.dart               # Définition de la police Montserrat
│   │   └── theme_manager.dart              # ThemeData clair & sombre Material 3
│   ├── utils/
│   │   └── snack_bar_message.dart          # Affichage standardisé des SnackBar
│   └── widgets/
│       └── loading_widget.dart             # Indicateur de chargement centralisé
└── features/                               # Découpage modulaire par domaine fonctionnel
    ├── auth/                               # Authentification & Profil utilisateur
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
    │   │       └── update_user.dart
    │   └── presentation/
    │       ├── blocs/
    │       │   ├── auth/{auth_bloc,event,state}.dart
    │       │   └── register/{register_bloc,event,state}.dart
    │       ├── screens/{login_screen, register_screen, profile_screen}.dart
    │       └── widgets/{auth_btn, login_form, register_form}.dart
    ├── listings/                           # Gestion des annonces immobilières (EF1, EF3, EF4, EF6, EF8)
    │   ├── data/
    │   │   ├── datasources/listing_data_source.dart  # HTTP REST + Fallback Asset Local
    │   │   ├── models/listing_model.dart             # JSON serialization (16 champs)
    │   │   └── repositories/listing_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/listing_entity.dart          # Entité métier immuable Equatable
    │   │   ├── repositories/listing_repository.dart  # Contrat abstrait
    │   │   └── usecases/
    │   │       ├── get_listings.dart                 # Récupération de la liste
    │   │       ├── search_listings.dart              # Recherche & filtrage
    │   │       └── add_listing.dart                  # Ajout d'un bien
    │   └── presentation/
    │       ├── blocs/
    │       │   ├── listings/{listings_bloc,event,state}.dart
    │       │   └── theme/{switchtheme_bloc,event,state}.dart
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
    └── favorites/                          # Gestion des favoris & persistance (EF5, EF7)
        ├── data/
        │   ├── datasources/favorites_local_data_source.dart # SharedPreferences
        │   └── repositories/favorites_repository_impl.dart
        ├── domain/
        │   ├── repositories/favorites_repository.dart
        │   └── usecases/
        │       ├── get_saved_listing_ids.dart
        │       └── toggle_saved_listing.dart
        └── presentation/
            ├── blocs/
            │   └── saved_listings/{saved_listings_bloc,event,state}.dart
            └── screens/
                └── saved_screen.dart
```

---

## 5. Captures d'Écran (`docs/screenshots/`)

Les captures d'écran des différents parcours utilisateurs de l'application sont stockées dans le dossier `docs/screenshots/` :

| Écran d'Accueil (`HomeScreen`) | Recherche Multicritère (`SearchScreen`) | Détail du Logement (`ListingDetailScreen`) |
| :---: | :---: | :---: |
| *Affichage des catégories et recommandations* | *Filtres par ville, loyer, pièces et type* | *Galerie, commodités et contact propriétaire* |
| **Mes Favoris (`SavedScreen`)** | **Publication (`PostListingScreen`)** | **Mode Sombre (Dark Theme)** |
| *Persistance locale et synchronisation* | *Formulaire validé avec sélecteur de date* | *Palette Material 3 Deep Teal inversée* |

---

## 6. Installation, Tests & Compilation

### Prérequis
- Flutter SDK `^3.47.0` (Dart `^3.13.0` ou compatible Dart 3)
- Android Studio / Android SDK configuré
- Navigateur Chrome ou appareil / émulateur Android

### Commandes Officielles

```bash
# 1. Cloner le dépôt GitHub
git clone https://github.com/yahiachokri928-hash/Sokna.git
cd Sokna

# 2. Récupérer toutes les dépendances
flutter pub get

# 3. Lancer l'analyse statique du code (Doit retourner 0 erreur / 0 warning)
flutter analyze

# 4. Exécuter l'ensemble des tests automatisés (Unitaires et Widgets)
flutter test

# 5. Lancer l'application en mode développement
flutter run

# 6. Compiler l'APK Android optimisé pour la soutenance (Release APK)
flutter build apk --release
```

Le fichier APK généré se trouvera dans :  
`build/app/outputs/flutter-apk/app-release.apk`

---

## 7. Règles Métier Appliquées (RG-01 à RG-05)

- **RG-01 (Loyer mensuel) :** Le prix de location doit impérativement être un entier strictement positif exprimé en Dinars Tunisiens (TND).
- **RG-02 (Nombre de pièces) :** Le nombre de pièces d'un bien varie entre 1 (Studio) et 6 (Grande Villa), configuré via un `Slider` interactif.
- **RG-03 (Unicité des favoris) :** Une annonce ne peut être ajoutée qu'une seule fois dans la liste des favoris (`Set`/`contains`).
- **RG-04 (Persistance légère) :** Seuls les identifiants textuels (`List<String>`) sont persistés dans `SharedPreferences` pour préserver l'espace de stockage et éviter les données désynchronisées.
- **RG-05 (Validation de publication) :** Tout formulaire incomplet bloque la soumission et affiche des messages explicites en français sous les champs erronés.

---

## 8. Auteur & Remerciements

Projet conçu et développé avec rigueur par :
- **Yahia Chokri** — Étudiant en DSI 3 (Développement des Systèmes d'Information), Institut Supérieur des Études Technologiques de Bizerte (ISET Bizerte).
- **Remerciements :** À **Mme Zouaghi Mounira** pour son encadrement pédagogique, ses conseils techniques et la qualité des séances d'atelier cross-platform.
