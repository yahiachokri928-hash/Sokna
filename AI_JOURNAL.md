# Journal de Bord IA (`AI_JOURNAL.md`) — Projet Sokna (سكنى)

**Étudiant :** Yahia Chokri (DSI 3 — ISET Bizerte)  
**Enseignante :** Mme Zouaghi Mounira  
**Exigence :** ENF8 — Traçabilité complète des interactions avec l'assistant IA et justification des choix d'architecture.

---

## Entrée 1 — Conception de l'Architecture et Fusion des Spécifications (Jalon J0)

- **Objectif :** Unifier une architecture Clean Architecture + BLoC (`flutter_bloc`, `get_it`, `go_router`, `dartz`) avec les exigences académiques EF1 à EF8 et ENF1 à ENF8 du cahier des charges Sokna.
- **Prompt / Demande :** Génération du fichier de règles `.agents/rules/sokna_architecture.md`, du plan d'exécution en 5 phases et de la documentation académique.
- **Décisions techniques retenues :**
  1. **Séparation stricte `domain` / `data` / `presentation` :** Garantit qu'aucune logique métier ne dépend de l'interface graphique ou de HTTP.
  2. **Sécurité BLoC 9.x :** Remplacement de tout appel direct à `emit()` dans les écouteurs de flux (`userStream.listen`) par le dispatch d'événements internes (`AuthUserChangedEvent`) et suppression des méthodes dépréciées `mapEventToState`.
  3. **Stratégie API REST + Fallback Offline (`EF6` & `ENF3`) :** Consommation du fichier `listings.json` hébergé sur GitHub Raw via `http.get`, avec chargement de secours depuis `assets/data/listings.json` via `rootBundle` en cas de coupure internet.
  4. **Persistance légère des favoris (`EF7` & `RG-04`) :** Stockage uniquement des identifiants `List<String>` dans `SharedPreferences` plutôt que la sérialisation complète des objets, évitant la désynchronisation avec l'API distante.

---

## Entrée 2 — Points Clés à Maîtriser pour la Soutenance Individuelle (Semaine S9)

- **Flux d'ajout d'une annonce (`EF3` + `EF4`) :** `PostListingForm` valide les champs via `GlobalKey<FormState>`, construit un `ListingEntity`, ferme l'écran avec `context.pop(newListing)` et dispatche `AddListingEvent` dans `ListingsBloc`.
- **Flux des favoris (`EF5` + `EF7`) :** `SavedListingsBloc` charge la liste des IDs au démarrage (`LoadSavedListingsEvent`), bascule un ID via `ToggleSavedListingEvent`, persiste immédiatement dans `SharedPreferences` et met à jour simultanément `ListingCard`, `ListingDetailScreen`, `SavedScreen` et le badge du `BottomNavigationBar`.
- **Filtrage temps réel (`EF8`) :** `SearchScreen` écoute le `TextEditingController` et filtre la liste en mémoire avec `.where()` sur la ville, le titre, la catégorie, le budget maximal et le nombre minimal de pièces.

*(Compléter ce journal au fur et à mesure des séances S6, S7 et S8 avec les captures et ajustements effectués.)*