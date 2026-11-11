# CAHIER DES CHARGES FONCTIONNEL ET TECHNIQUE
## PROJET D'ATELIER CROSS-PLATFORM (FLUTTER) — DSI 3 (2026-2027)

---

**Nom du Projet :** Sokna (سكنى)  
**Établissement :** Institut Supérieur des Études Technologiques de Bizerte (ISET Bizerte)  
**Département :** Technologies de l'Informatique — Parcours DSI (Développement des Systèmes d'Information)  
**Enseignante responsable :** Mme Zouaghi Mounira  
**Étudiant développeur :** Yahia Chokri (Travail individuel / Solo)  
**Dépôt GitHub de référence :** [https://github.com/yahiachokri928-hash/Sokna](https://github.com/yahiachokri928-hash/Sokna)  
**Statut du document :** Proposition formelle de spécification avant validation pédagogique (Jalon J0)

---

## 1. PRÉSENTATION GÉNÉRALE DU PROJET

### 1.1 Contexte académique
Dans le cadre de l'Atelier Cross-Platform de la 3ème année Licence Appliquée DSI à l'ISET Bizerte, les étudiants sont amenés à concevoir et développer une application mobile multiplateforme complète, robuste et ergonomique en utilisant le framework **Flutter** et le langage **Dart**. Le projet s'étend sur 4 semaines de développement intensif (Semaines S5 à S8), avec des jalons d'évaluation intermédiaires hebdomadaires, et se clôture en Semaine S9 par une soutenance individuelle stricte combinant une démonstration fonctionnelle et une session de programmation en direct sans assistance IA.

### 1.2 Problématique locale
En Tunisie, la recherche de logements en location (notamment pour les étudiants universitaires, jeunes diplômés et familles) souffre d'un manque criant de centralisation et de transparence. Les démarches s'effectuent majoritairement via des groupes de réseaux sociaux informels ou des intermédiaires informels (*sansara*), entraînant :
- Des annonces non structurées et obsolètes ;
- Une absence de filtres précis (fourchette de prix en Dinars Tunisiens TND, typologie S+1, S+2, présence de commodités) ;
- L'impossibilité de sauvegarder et comparer facilement des biens hors ligne ou au fil des sessions.

### 1.3 Synthèse en une phrase (Exigence Jalon J0)
> **« Sokna est une application mobile Flutter permettant aux locataires en Tunisie de rechercher, filtrer et sauvegarder des annonces de logements claires et géolocalisées, et aux propriétaires de publier et gérer leurs offres de location en toute simplicité. »**

---

## 2. PÉRIMÈTRE ET AUDIT COMPARATIF (PDF vs RÉPERTOIRE)

### 2.1 Analyse de l'existant dans le dépôt GitHub
L'inspection intégrale du dépôt distant et local révèle :
- **État d'avancement du code :** Néant (`0%` d'implémentation). Le répertoire ne contient aucun projet Flutter généré (absence de `pubspec.yaml`, de `lib/`, de `test/` ou de configuration plateforme Android/iOS).
- **Fichiers présents :** 
  - `.gitattributes`
  - `documents uni/Cahier_des_charges_Projet_Flutter.pdf` (Cahier des charges officiel de l'enseignante)
  - `documents uni/wireframe all screens combined.pdf` (Maquette graphique de référence pour l'application "Kra Dyar")
- **Historique Git :** 1 seul commit initial (`Initial commit`). 
- **Conséquence directe :** L'intégralité du socle architectural et fonctionnel doit être mise en place de manière rigoureuse, sans aucune dette technique préexistante.

### 2.2 Analyse de la maquette de référence ("Kra Dyar")
Le document d'interface joint illustre un workflow double (Locataire / Propriétaire) comportant :
1. **Écran d'Accueil Locataire (Home) :** Salutation personnalisée, barre de recherche rapide, sélecteur horizontal de typologie (*All, Apart., House, Studio*), carte mise en avant avec badge vérifié et favori.
2. **Écran de Recherche & Filtres (Search) :** Champ textuel par ville/quartier, bascule d'affichage, barres de filtres contextuels (*Prix ▾, Pièces ▾, Plus ▾*), liste paginée des résultats avec distance et notation.
3. **Écran Détail du Logement (Listing Detail) :** Galerie visuelle, carrousel d'indicateurs (pièces, surface en m², meublé, parking, disponibilité, caution), description textuelle, fiche propriétaire vérifié, avis locataires, bouton d'action favori et messagerie.
4. **Tunnel de Dépôt Propriétaire (Create Listing) :** Assistant en 4 étapes :
   - Étape 1 : Photos & Modélisation 3D ;
   - Étape 2 : Détails (Titre, Description, Typologie, Prix, Pièces, Surface, Étage, Ville) ;
   - Étape 3 : Options & Commodités (Wifi, Parking, Animaux, Ascenseur, Climatisation, Disponibilité, Contact) ;
   - Étape 4 : Récapitulatif et Confirmation de publication.

---

## 3. ACTEURS ET CAS D'UTILISATION

### 3.1 Acteurs du système
- **Le Locataire (Utilisateur principal) :** Consulte les offres disponibles, effectue des recherches multicritères, consulte les détails techniques et financiers d'un bien, conserve des annonces en favoris persistants.
- **Le Propriétaire / Bailleur :** Saisit et publie de nouvelles annonces de location via un formulaire de dépôt contrôlé et validé.
- **Le Système / API Distante :** Fournit le catalogue initial d'annonces au format JSON hébergé en ligne.

### 3.2 Diagramme textuel des Cas d'Utilisation
```
[ Locataire ]
      ├── (UC01) Parcourir les logements recommandés (Accueil)
      ├── (UC02) Filtrer les logements par type (S+, Studio, Maison)
      ├── (UC03) Rechercher par mot-clé et ville avec actualisation instantanée
      ├── (UC04) Consulter la fiche détaillée d'un bien sélectionné
      └── (UC05) Ajouter / Retirer un logement de la liste des Favoris (persistance locale)

[ Propriétaire ]
      └── (UC06) Déposer une nouvelle annonce de location via formulaire validé
```

---

## 4. EXIGENCES FONCTIONNELLES OBLIGATOIRES (EF1 À EF8)

La grille du cours impose 8 exigences fonctionnelles strictes, associées aux séances d'atelier. Voici leur déclinaison exacte dans **Sokna** :

| Réf. | Exigence du Cahier des Charges | Implémentation concrète dans Sokna | Notion Flutter associée |
| :--- | :--- | :--- | :--- |
| **EF1** | **Au moins 4 écrans différents**, dont une liste et un détail | **5 écrans dédiés :**<br>1. `HomeScreen` (Accueil & Catégories)<br>2. `SearchScreen` (Recherche & Filtres multicritères)<br>3. `ListingDetailScreen` (Fiche complète du bien)<br>4. `SavedScreen` (Gestionnaire des Favoris)<br>5. `PostListingScreen` (Dépôt d'annonce propriétaire) | Widgets structurels, Scaffold, Layouts adaptatifs |
| **EF2** | **Navigation avec passage de données** (liste vers détail) | Clic sur une carte d'annonce (`ListingCard`) déclenchant l'ouverture de `ListingDetailScreen` en passant l'instance complète du modèle `Listing` en paramètre de route. | `Navigator.push(context, MaterialPageRoute(...))` |
| **EF3** | **Formulaire validé** : min. 3 champs, min. 2 types de saisie, messages clairs | Formulaire de dépôt d'annonce (`PostListingScreen`) comprenant :<br>- Titre (*TextFormField*, min. 5 caractères)<br>- Prix mensuel (*TextFormField* numérique, valeur > 0)<br>- Type de bien (*DropdownButtonFormField* : Studio, S+1, S+2, Villa)<br>- Nombre de pièces (*Slider* interactif de 1 à 6)<br>- Date de disponibilité (*showDatePicker* avec champ dédié)<br>- Logement meublé (*SwitchListTile* ou *CheckboxListTile*) | `Form`, `GlobalKey<FormState>`, `TextFormField`, validateurs |
| **EF4** | **Résultat renvoyé à l'écran précédent** | Lors de la soumission réussie du formulaire, `PostListingScreen` effectue un `pop` en renvoyant l'objet `Listing` créé. L'écran appelant intercepte la valeur et affiche un `SnackBar` de confirmation avec mise à jour immédiate. | `Navigator.pop(context, newListing)` |
| **EF5** | **État partagé visible sur au moins 2 écrans** | Utilisation de `SavedListingsProvider` étendant `ChangeNotifier` :<br>- **Écran 1 (`ListingDetailScreen`) :** L'icône cœur reflète dynamiquement l'état (plein/vide) et permet le basculement.<br>- **Écran 2 (`SavedScreen`) :** Affiche la liste synchronisée des biens favoris.<br>- **Barre de navigation :** Badge numérique affichant le nombre total de favoris. | `Provider`, `ChangeNotifier`, `Consumer` |
| **EF6** | **Données externes lues depuis une API REST**, gestion chargement & erreurs | Consommation d'un fichier distant `listings.json` hébergé sur le dépôt GitHub (Lien Raw) contenant au minimum 15 éléments réalistes tunisiens, traité via le package `http`, désérialisé en liste d'objets `Listing`, et rendu via `FutureBuilder` (gérant `ConnectionState.waiting`, `hasError` et affichage des données). | `http.get`, `jsonDecode`, `FutureBuilder` |
| **EF7** | **Persistance locale** retrouvée après redémarrage | Sauvegarde de la liste des identifiants (`List<String>`) des annonces favorites dans le stockage persistant du smartphone via `shared_preferences`. Chargement asynchrone à l'initialisation de l'application. | `shared_preferences` (`setStringList`, `getStringList`) |
| **EF8** | **Recherche ou filtre sur une liste** | Filtrage dynamique dans `SearchScreen` :<br>- Recherche textuelle instantanée par ville/titre via méthode `.where()` sur la liste en mémoire ;<br>- Filtrage par catégorie/typologie (Tous, Appartement, Maison, Studio) ;<br>- Actualisation de l'affichage via `setState`. | `TextEditingController`, `.where()`, `setState()` |

---

## 5. EXIGENCES NON FONCTIONNELLES (ENF1 À ENF8)

| Réf. | Domaine | Règle imposée par l'enseignante | Application dans le projet Sokna |
| :--- | :--- | :--- | :--- |
| **ENF1** | **Ergonomie** | Respect strict de la grille des TP 3 et 4 : espacements 8/16/24 dp, hiérarchie typographique, cibles tactiles minimales de 48x48 dp, cohérence visuelle. | Marges normalisées, boutons ergonomiques et affichage clair en français. |
| **ENF2** | **Thème** | Material 3 obligatoire avec `ColorScheme.fromSeed`. Aucune couleur hexadécimale codée en dur si le thème propose un équivalent sémantique. | Couleur sémantique racine : Vert canard / Teal profond (`#1A6B5A`), symbolisant la stabilité et l'immobilier. Utilisation de `Theme.of(context).colorScheme`. |
| **ENF3** | **Robustesse** | **Aucun débordement visuel** (bandes jaunes et noires d'*overflow*) en mode portrait. Tolérance aux pannes réseau (mode hors-ligne sans crash). | Utilisation systématique de `SingleChildScrollView`, `ListView.builder` et blocs `try / catch` enveloppant les requêtes HTTP. |
| **ENF4** | **Organisation** | Structure imposée de dossiers explicites : `models/`, `screens/`, `widgets/`, `providers/`, `services/`. **Un seul widget par fichier**. | Respect strict de l'arborescence standardisée (voir Section 8). |
| **ENF5** | **Gestion Git** | Minimum de **20 commits réguliers** et explicites, respectant les conventions (`feat:`, `fix:`, `docs:`). | Découpage atomique des commits synchronisé avec les jalons pédagogiques. |
| **ENF6** | **Documentation** | Fichier `README.md` exhaustif comportant : description, captures d'écran, fiche projet J0, API utilisée, consignes de build. | Rédaction d'un README complet conforme à la section 10 du document enseignant. |
| **ENF7** | **Livraison** | Un fichier APK fonctionnel (`app-release.apk`) généré et attaché aux Releases GitHub. | Compilation finale via `flutter build apk --release`. |
| **ENF8** | **Traçabilité IA** | Tenue obligatoire du `AI_JOURNAL.md` détaillant chaque invite (*prompt*), réponse et justification des choix retenus. | Création et enrichissement continu du journal de bord IA. |

---

## 6. DESCRIPTION DÉTAILLÉE DES INTERFACES (SCREENS)

### Écran 1 : `HomeScreen` (Accueil & Découverte)
- **Rôle :** Point d'entrée principal pour le locataire.
- **En-tête :** Salutation conviviale (« Bonjour, Yahia 👋 »), sous-titre contextualisé (« Trouvez votre futur chez-vous en Tunisie »).
- **Zone de sélection :** Sélecteur horizontal de filtres rapides (*Tous, Appartement, Villa, Studio*).
- **Corps :** Section « Recommandés pour vous » alimentée par `FutureBuilder` consommant le service HTTP.
- **Composant carte (`ListingCard`) :** Image illustrative, pastille de prix en Dinars Tunisiens (« 750 TND / mois »), titre descriptif (« S+2 meublé — La Marsa »), caractéristiques clés (surface, pièces), bouton d'action favori rapide.

### Écran 2 : `SearchScreen` (Recherche & Filtres dynamiques)
- **Rôle :** Outil d'exploration multicritère (Satisfait **EF8**).
- **Composants de saisie :** Champ de saisie de recherche (écouteur sur ville ou quartier : Ariana, Tunis, Bizerte, Sousse...), puces de filtrage de typologie.
- **Indicateur de statut :** Affichage en temps réel du nombre de résultats trouvés (« 14 logements disponibles »).
- **Gestion des états vides :** Si aucun logement ne correspond aux critères, affichage d'un composant illustré `EmptyState` avec bouton de réinitialisation.

### Écran 3 : `ListingDetailScreen` (Fiche Logement Complète)
- **Rôle :** Vue détaillée après navigation (Satisfait **EF1, EF2, EF5**).
- **Galerie d'en-tête :** Affichage d'image avec bouton retour et bouton flottant de mise en favori (synchronisé avec `SavedListingsProvider`).
- **Bloc financier :** Loyer mensuel, montant de la caution exigée (ex: 2 mois).
- **Grille de commodités :** Badges standardisés (Nombre de chambres, Surface en m², Meublé / Non-meublé, Place de parking disponible).
- **Section Descriptive :** Texte explicatif de l'annonce, date exacte de disponibilité.
- **Fiche Bailleur :** Nom du propriétaire, statut « Bailleur vérifié », note de confiance.
- **Barre d'action inférieure :** Bouton pleine largeur « Contacter le propriétaire » déclenchant une alerte contextuelle.

### Écran 4 : `SavedScreen` (Mes Favoris)
- **Rôle :** Visualisation des annonces sauvegardées par l'utilisateur (Satisfait **EF5, EF7**).
- **Comportement dynamique :** Écoute les modifications de `SavedListingsProvider`.
- **Gestion locale :** Permet de retirer une annonce de ses favoris directement depuis la liste.
- **État vide :** Message explicatif invitant à explorer les offres si aucun favori n'est enregistré.

### Écran 5 : `PostListingScreen` (Dépôt d'Annonce Bailleur)
- **Rôle :** Formulaire de saisie d'un nouveau bien (Satisfait **EF3, EF4**).
- **Champs contrôlés :**
  1. *Titre de l'annonce :* Contrôle de longueur minimale (5 caractères).
  2. *Ville / Région :* Champ obligatoire.
  3. *Loyer mensuel (TND) :* Validation numérique stricte.
  4. *Type de propriété :* Sélection exclusive via menu déroulant.
  5. *Nombre de pièces :* Curseur interactif (*Slider*) de 1 à 6 pièces avec indicateur numérique.
  6. *Date de disponibilité :* Sélecteur de date natif (*DatePicker*).
  7. *Option Meublé :* Interrupteur booléen.
- **Validation & Retour :** Bouton « Publier l'annonce » déclenchant `_formKey.currentState!.validate()`. Si valide, instanciation du modèle et exécution de `Navigator.pop(context, newListing)`.

---

## 7. RÈGLES DE GESTION MÉTIER (BUSINESS RULES)

1. **RG-01 (Tarification en TND) :** Tous les montants financiers sont exprimés en Dinars Tunisiens entiers positifs non nuls.
2. **RG-02 (Typologie reconnue) :** Une annonce appartient strictement à l'une des catégories : *Studio, Appartement, Villa, Maison*.
3. **RG-03 (Unicité des favoris) :** Un même logement ne peut être présent qu'une seule fois dans la liste des favoris de l'utilisateur.
4. **RG-04 (Persistance sélective) :** Seuls les identifiants uniques (`id`) des logements favoris sont stockés dans `SharedPreferences` afin d'optimiser l'espace mémoire et d'assurer l'intégrité référentielle avec le jeu de données distant.
5. **RG-05 (Validation de complétude) :** Aucune annonce ne peut être ajoutée sans titre, ville, loyer strictement supérieur à 0 et date de disponibilité sélectionnée.

---

## 8. ARCHITECTURE TECHNIQUE ET MODÈLE DE DONNÉES

### 8.1 Pattern Architectural : MVC Pragmatique avec Provider
Conformément aux objectifs pédagogiques de l'ISET, l'architecture retenue sépare rigoureusement la logique métier, la présentation et les données sans complexité superflue (afin de garantir une maîtrise totale lors de la soutenance individuelle en direct) :
- **Models :** Encapsulation des données et sérialisation JSON.
- **Services :** Appels réseau asynchrones et parsing HTTP.
- **Providers :** État applicatif réactif pour les données transversales (Favoris).
- **Screens :** Vues associées aux routes principales.
- **Widgets :** Éléments d'interface atomiques et réutilisables.

### 8.2 Arborescence des fichiers du projet (`lib/`)
```
lib/
├── main.dart                          # Point d'entrée, MultiProvider, Material3 Theme
├── models/
│   └── listing.dart                   # Classe modèle Listing, fromJson et toJson
├── providers/
│   └── saved_listings_provider.dart   # Gestion de l'état des favoris & SharedPreferences
├── services/
│   └── listing_service.dart           # Service REST HTTP (consommation du JSON raw)
├── screens/
│   ├── home_screen.dart               # Écran d'accueil principal (EF1, EF6)
│   ├── search_screen.dart             # Écran de recherche et filtrage dynamique (EF8)
│   ├── listing_detail_screen.dart     # Fiche détaillée de l'annonce (EF2, EF5)
│   ├── saved_screen.dart              # Écran des annonces favorites (EF5, EF7)
│   └── post_listing_screen.dart       # Formulaire de publication d'annonce (EF3, EF4)
├── widgets/
│   ├── listing_card.dart              # Carte d'affichage d'un logement
│   ├── category_filter_bar.dart       # Barre horizontale de filtres de catégorie
│   ├── amenity_badge.dart             # Pastille visuelle pour les commodités (m², pièces)
│   └── custom_empty_state.dart        # Affichage convivial en cas de liste vide
└── theme/
    └── app_theme.dart                 # Configuration ColorScheme.fromSeed Material 3
```

### 8.3 Modèle Conceptuel de Données (`Listing`)

```dart
class Listing {
  final String id;             // Identifiant unique (ex: "sokna_001")
  final String title;          // Titre (ex: "S+2 meublé vue sur mer")
  final String city;           // Ville (ex: "La Marsa", "Bizerte", "Sousse")
  final String address;        // Adresse textuelle
  final String propertyType;   // "Appartement", "Villa", "Studio"
  final int price;             // Loyer mensuel en Dinars Tunisiens (TND)
  final int rooms;             // Nombre de pièces
  final double surface;        // Surface habitable en m²
  final bool isFurnished;      // Logement meublé (true/false)
  final bool hasParking;       // Place de parking (true/false)
  final String imagePath;      // Chemin local asset ou URL placeholder
  final double rating;         // Note d'évaluation (ex: 4.8)
  final int reviewCount;       // Nombre d'avis recueillis
  final String ownerName;      // Nom du bailleur
  final String availableFrom;  // Date de disponibilité (ex: "2026-09-01")
  final String description;    // Descriptif complet du bien
}
```

### 8.4 Stratégie de l'API REST (« JSON Maison » - EF6)
Conformément au point 2.2 de la page 2 du cahier des charges de l'enseignante :
- Un fichier `assets/data/listings.json` contenant au minimum 16 annonces réalistes situées dans diverses régions tunisiennes (Tunis, Ariana, Bizerte, La Marsa, Nabeul, Sousse) sera créé et versionné sur la branche principale du dépôt GitHub.
- L'application consommera l'URL brute (*Raw URL*) :  
  `https://raw.githubusercontent.com/yahiachokri928-hash/Sokna/main/assets/data/listings.json`
- Une stratégie de secours (*fallback*) locale permettra de charger le fichier embarqué en local en cas d'absence totale de réseau, respectant l'exigence **ENF3** (l'application ne plante jamais).

---

## 9. PLANNING PRÉVISIONNEL ET CALENDRIER DES JALONS

Le projet s'aligne scrupuleusement sur les jalons fixés par Mme Zouaghi Mounira :

```
[S5] Jalon J0 (Fin S5) : Fiche projet complétée + Maquette + Dépôt initialisé
  │
[S6] Jalon J1 (Fin S6) : Squelette applicatif (5 écrans, navigation EF1/EF2 avec données fictives)
  │
[S7] Jalon J2 (Fin S7) : Données fonctionnelles (Formulaire EF3, Pop EF4, Provider EF5, API EF6)
  │
[S8] Jalon J3 (Fin S8) : Version finale complète (Persistance EF7, Filtres EF8, README, APK, Journal IA)
  │
[S9] Soutenance : Démonstration (5 min) + Défense individuelle sans IA (10 min) + Questions (5 min)
```

---

## 10. FICHE PROJET OFFICIELLE (POUR LE README - JALON J0)

*À insérer dans le README.md dès validation du thème :*

| Rubrique | Réponse officielle |
| :--- | :--- |
| **Nom de l'application** | **Sokna (سكنى)** |
| **Membres du binôme** | Yahia Chokri (Travail individuel / Solo) |
| **Lien du dépôt GitHub** | [https://github.com/yahiachokri928-hash/Sokna](https://github.com/yahiachokri928-hash/Sokna) |
| **Le besoin, en une phrase** | Permettre aux locataires en Tunisie de trouver et sauvegarder un logement adapté à leur budget, et aux propriétaires de déposer leurs annonces facilement. |
| **Liste des écrans (min. 4)** | 1. Accueil (`HomeScreen`)<br>2. Recherche & Filtres (`SearchScreen`)<br>3. Détail du Logement (`ListingDetailScreen`)<br>4. Favoris (`SavedScreen`)<br>5. Publication d'annonce (`PostListingScreen`) |
| **Le formulaire (EF3) : champs** | Titre (texte), Ville (texte), Prix (numérique), Type (liste déroulante), Pièces (curseur), Date de disponibilité (sélecteur de date), Meublé (case à cocher). |
| **L'état partagé (EF5)** | Gestion des logements favoris (`SavedListingsProvider`) synchronisée entre l'écran Détail, l'écran des Favoris et le badge de navigation. |
| **L'API (EF6) : nom et lien** | JSON maison hébergé sur GitHub Raw (16 logements tunisiens) consommé via le package `http`. |
| **La donnée persistée (EF7)** | La liste des identifiants (`id`) des annonces favorites sauvegardée dans `shared_preferences`. |
| **Bonus envisagé (facultatif)** | Mode sombre automatique (*Dark Mode*) ou 3 tests de widgets unitaires (`flutter test`). |
| **Répartition prévue du travail** | Réalisation individuelle intégrale : conception, maquettage, développement Flutter, tests et documentation. |

---

## 11. GESTION DES RISQUES TECHNIQUES ET ACADÉMIQUES

| Risque identifié | Niveau d'impact | Mesure préventive adoptée |
| :--- | :--- | :--- |
| **Refus du thème par l'enseignante** | Critique | Présenter immédiatement la fiche J0 et s'assurer de son ancrage local tunisien évident. |
| **Dépendance réseau fragile en soutenance** | Élevé | Mise en place d'un *cache / fallback* local sur asset JSON pour continuer la démo même sans Wi-Fi. |
| **Code trop complexe pour la défense sans IA** | Élevé | Bannir les architectures lourdes (BLoC, Clean Architecture abstraite) au profit d'un MVC direct et limpide avec `Provider`. |
| **Dépassement d'écran (*Overflow*) sur petit téléphone** | Moyen | Emploi exclusif de vues déroulantes (`ListView`, `SingleChildScrollView`) et widgets souples (`Expanded`, `Flexible`). |

---

## 12. QUESTIONS À CLARIFIER AVEC L'ENSEIGNANTE AVANT VALIDATION

Avant d'exécuter la phase d'implémentation (création du projet Flutter), les points suivants doivent être impérativement validés avec Mme Zouaghi Mounira :

1. **Validation formelle du thème :** Confirmez-vous que le thème de location immobilière « Sokna » est validé comme thème original pour un étudiant travaillant seul ?
2. **Autorisation du travail individuel (Solo) :** Le cahier des charges prévoyant un travail en binôme par défaut, l'enseignante autorise-t-elle explicitement la réalisation en solo avec le barème standard ?
3. **Format du jeu de données « JSON Maison » :** La lecture du fichier JSON brut hébergé directement sur le dépôt GitHub via `http.get` répond-elle exactement à l'exigence EF6 pour ce thème ?
4. **Appellation définitive :** Souhaitez-vous conserver le nom « Sokna » ou adopter le nom présent sur la maquette « Kra Dyar » ?

---

*(Fin du document de spécification — En attente de votre revue et de vos instructions expresses).*
