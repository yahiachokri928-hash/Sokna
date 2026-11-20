# Sokna (سكنى) — Application Mobile de Location Immobilière en Tunisie

Application mobile multiplateforme développée avec **Flutter** et **Dart** dans le cadre de l'**Atelier Cross-Platform (DSI 3 — 2026/2027)** à l'**Institut Supérieur des Études Technologiques de Bizerte (ISET Bizerte)**, sous l'encadrement de **Mme Zouaghi Mounira**.

---

## 1. Fiche Projet Officielle (Jalon J0)

| Rubrique | Réponse officielle |
| :--- | :--- |
| **Nom de l'application** | **Sokna (سكنى)** |
| **Membres du binôme** | Yahia Chokri (Travail individuel / Solo) |
| **Lien du dépôt GitHub** | https://github.com/yahiachokri928-hash/Sokna |
| **Le besoin, en une phrase** | Permettre aux locataires en Tunisie de rechercher, filtrer et sauvegarder des annonces de logements claires et géolocalisées, et aux propriétaires de publier et gérer leurs offres de location en toute simplicité. |
| **Liste des écrans (min. 4)** | 1. Accueil (`HomeScreen`)<br>2. Recherche & Filtres (`SearchScreen`)<br>3. Détail du Logement (`ListingDetailScreen`)<br>4. Favoris (`SavedScreen`)<br>5. Publication d'annonce (`PostListingScreen`)<br>*(+ Authentification & Profil : `LoginScreen`, `RegisterScreen`, `ProfileScreen`)* |
| **Le formulaire (EF3) : champs** | Titre (texte >= 5 car.), Ville (texte), Adresse (texte), Loyer mensuel TND (numérique > 0), Type de bien (liste déroulante : Studio, Appartement, Villa, Maison), Nombre de pièces (curseur `Slider` 1 à 6), Surface m² (numérique), Date de disponibilité (`showDatePicker`), Meublé (`SwitchListTile`), Parking (`CheckboxListTile`). |
| **L'état partagé (EF5)** | Gestion réactive des logements favoris (`SavedListingsBloc`) synchronisée entre `ListingCard`, `ListingDetailScreen`, `SavedScreen` et le badge numérique de la barre de navigation. |
| **L'API (EF6) : nom et lien** | API REST JSON maison hébergée sur GitHub Raw (`16` logements tunisiens) consommée via le package `http` avec secours local (`assets/data/listings.json`) :<br>`https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json` |
| **La donnée persistée (EF7)** | La liste des identifiants uniques (`List<String>`) des annonces favorites sauvegardée localement via `shared_preferences`. |
| **Bonus envisagé** | Mode sombre dynamique (`SwitchthemeBloc` + Material 3) et suite de tests unitaires et de widgets (`flutter test`). |
| **Répartition prévue du travail** | Réalisation individuelle intégrale : conception, architecture Clean Architecture / BLoC, développement Flutter, tests et documentation. |

---

## 2. Architecture Technique

Le projet suit une **Clean Architecture** stricte découpée par fonctionnalités (`features/listings`, `features/favorites`, `features/auth`) et un socle partagé (`core/`) :

- **Gestion d'état :** `flutter_bloc` (`ListingsBloc`, `SavedListingsBloc`, `AuthBloc`, `RegisterBloc`, `SwitchthemeBloc`)
- **Gestion des erreurs :** `dartz` (`Either<Failure, T>`) + exceptions typées
- **Injection de dépendances :** `get_it` (`lib/core/di/service_locator.dart`)
- **Navigation :** `go_router` (`ShellRoute` avec barre de navigation inférieure et garde d'authentification)
- **Thème :** Material 3 (`ColorScheme.fromSeed` basé sur `#1A6B5A` Teal profond) + typographie `Montserrat`

---

## 3. Installation, Tests & Compilation

```bash
# 1. Cloner le dépôt
git clone [https://github.com/yahiachokri928-hash/Sokna.git](https://github.com/yahiachokri928-hash/Sokna.git)
cd Sokna

# 2. Installer les dépendances Flutter
flutter pub get

# 3. Vérifier la qualité statique du code
flutter analyze

# 4. Lancer les tests unitaires et de widgets
flutter test

# 5. Lancer l'application en développement
flutter run

# 6. Générer l'APK Release (Livrable ENF7)
flutter build apk --release
```