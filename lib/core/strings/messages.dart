// ignore_for_file: constant_identifier_names

// Centralized UI and validation messages in SCREAMING_SNAKE_CASE (ENF1, ENF2)

const String APP_TITLE = "Sokna";
const String APP_SUBTITLE = "Location immobilière en Tunisie";

// Navigation bar items
const String NAV_HOME = "Accueil";
const String NAV_SEARCH = "Recherche";
const String NAV_SAVED = "Favoris";
const String NAV_PROFILE = "Profil";
const String NAV_POST = "Publier";

// Home screen
const String HOME_USER_GREETING = "Bonjour, Yahia 👋";
const String HOME_GREETING_TITLE = "Trouvez votre futur logement";
const String HOME_GREETING_SUBTITLE = "Des centaines d'annonces vérifiées en Tunisie";
const String HOME_SECTION_CATEGORIES = "Types de biens";
const String HOME_SECTION_RECOMMENDED = "Annonces récentes";
const String HOME_SEARCH_PLACEHOLDER = "Rechercher par ville (Tunis, Marsa, Sousse...)";

// Categories
const String CATEGORY_ALL = "Tous";
const String CATEGORY_STUDIO = "Studio";
const String CATEGORY_APPARTEMENT = "Appartement";
const String CATEGORY_VILLA = "Villa";
const String CATEGORY_MAISON = "Maison";

// Search screen
const String SEARCH_TITLE = "Rechercher une location";
const String SEARCH_INPUT_LABEL = "Ville, quartier ou mot-clé";
const String SEARCH_FILTER_TYPE = "Type de bien";
const String SEARCH_FILTER_PRICE = "Loyer mensuel maximum";
const String SEARCH_FILTER_ROOMS = "Nombre de pièces minimum";
const String SEARCH_RESULTS_SUFFIX = "logement(s) disponible(s)";
const String SEARCH_NO_RESULTS = "Aucun logement ne correspond à vos filtres.";
const String SEARCH_RESET_FILTERS = "Réinitialiser les filtres";
const String SEARCH_ALL_REGIONS = "Toutes les régions";
const String SEARCH_FILTER_SECTION = "Filtres avancés";

// Listing card & badges
const String LISTING_CARD_VERIFIED = "Vérifié";
const String LISTING_ROOM_PREFIX = "S+";

// Listing detail screen
const String DETAIL_APP_BAR_TITLE = "Détail du logement";
const String DETAIL_PRICE_UNIT = "TND / mois";
const String DETAIL_CHARACTERISTICS = "Caractéristiques";
const String DETAIL_SURFACE_UNIT = "m²";
const String DETAIL_ROOMS_COUNT = "pièce(s)";
const String DETAIL_FURNISHED_YES = "Meublé";
const String DETAIL_FURNISHED_NO = "Non meublé";
const String DETAIL_PARKING_YES = "Parking privé";
const String DETAIL_PARKING_NO = "Sans parking";
const String DETAIL_AVAILABLE_DATE = "Disponible à partir du";
const String DETAIL_OWNER_SECTION = "Bailleur vérifié";
const String DETAIL_VERIFIED_LANDLORD = "Propriétaire vérifié par Sokna";
const String DETAIL_DEPOSIT_TITLE = "Caution de garantie (2 mois)";
const String DETAIL_TOTAL_INITIAL = "Total initial requis";
const String DETAIL_CONTACT_BUTTON = "Contacter le propriétaire";
const String DETAIL_DESCRIPTION_SECTION = "Description du bien";
const String DETAIL_DIALOG_CONTACT_TITLE = "Contacter le bailleur";
const String DETAIL_DIALOG_CONTACT_MESSAGE = "Voulez-vous contacter le propriétaire pour ce bien ?";
const String DETAIL_DIALOG_CALL = "Appeler";
const String DETAIL_DIALOG_SMS = "Envoyer un SMS";

// Post listing screen & form
const String POST_APP_BAR_TITLE = "Déposer une annonce";
const String POST_FIELD_TITLE = "Titre de l'annonce";
const String POST_FIELD_CITY = "Gouvernorat / Ville";
const String POST_FIELD_ADDRESS = "Adresse complète";
const String POST_FIELD_TYPE = "Type de logement";
const String POST_FIELD_PRICE = "Loyer mensuel (TND)";
const String POST_FIELD_ROOMS = "Nombre de pièces (1 à 6)";
const String POST_FIELD_SURFACE = "Surface habitable (m²)";
const String POST_FIELD_IMAGE = "URL de l'image";
const String POST_FIELD_OWNER = "Nom et prénom du bailleur";
const String POST_FIELD_DATE = "Date de disponibilité";
const String POST_FIELD_DESCRIPTION = "Description détaillée du logement";
const String POST_SWITCH_FURNISHED = "Logement meublé";
const String POST_SWITCH_PARKING = "Place de parking incluse";
const String POST_SUBMIT_BUTTON = "Publier l'annonce";
const String POST_SUCCESS_MESSAGE = "Votre annonce a été publiée avec succès !";
const String POST_LOGIN_REQUIRED_MESSAGE = "Veuillez vous connecter pour publier une annonce.";
const String LISTING_DELETE_CONFIRM_TITLE = "Supprimer l'annonce";
const String LISTING_DELETE_CONFIRM_MESSAGE = "Êtes-vous sûr de vouloir supprimer cette annonce définitivement ?";
const String LISTING_DELETE_SUCCESS = "L'annonce a été supprimée avec succès !";
const String LISTING_DELETE_BUTTON = "Supprimer";
const String PROFILE_MY_LISTINGS_TITLE = "Mes annonces publiées";
const String PROFILE_NO_LISTINGS = "Vous n'avez publié aucune annonce pour le moment.";
const String PROFILE_PUBLISH_FIRST_LISTING = "Publier ma première annonce";

// Form validation messages (RG-01, RG-02, RG-05)
const String VALIDATION_REQUIRED = "Ce champ est obligatoire";
const String VALIDATION_TITLE_MIN_LENGTH = "Le titre doit comporter au moins 5 caractères";
const String VALIDATION_PRICE_POSITIVE = "Le loyer doit être un entier strictement positif (> 0)";
const String VALIDATION_SURFACE_POSITIVE = "La surface doit être supérieure à 0 m²";
const String VALIDATION_INVALID_EMAIL = "Veuillez saisir une adresse e-mail valide";
const String VALIDATION_PASSWORD_MIN_LENGTH = "Le mot de passe doit comporter au moins 6 caractères";
const String VALIDATION_DATE_REQUIRED = "Veuillez sélectionner une date de disponibilité";

// Saved / Favorites screen
const String SAVED_APP_BAR_TITLE = "Mes favoris";
const String SAVED_EMPTY_TITLE = "Aucun favori enregistré";
const String SAVED_EMPTY_SUBTITLE = "Cliquez sur l'icône cœur pour sauvegarder vos logements préférés.";
const String SNACKBAR_FAVORITE_ADDED = "Logement ajouté à vos favoris";
const String SNACKBAR_FAVORITE_REMOVED = "Logement retiré de vos favoris";
const String LOGIN_REQUIRED_FAVORITES_MESSAGE =
    "Veuillez vous connecter pour enregistrer des favoris.";

// Auth screens (Login, Register, Profile)
const String AUTH_LOGIN_TITLE = "Connexion";
const String AUTH_LOGIN_SUBTITLE = "Bienvenue sur Sokna !";
const String AUTH_REGISTER_TITLE = "Inscription";
const String AUTH_REGISTER_SUBTITLE = "Rejoignez la communauté Sokna";
const String AUTH_FIELD_NAME = "Nom complet";
const String AUTH_FIELD_EMAIL = "Adresse e-mail";
const String AUTH_FIELD_PASSWORD = "Mot de passe";
const String AUTH_FIELD_PHONE = "Numéro de téléphone";
const String AUTH_LOGIN_BUTTON = "Se connecter";
const String AUTH_REGISTER_BUTTON = "Créer mon compte";
const String AUTH_LOGOUT_BUTTON = "Se déconnecter";
const String AUTH_NO_ACCOUNT = "Vous n'avez pas de compte ? S'inscrire";
const String AUTH_HAVE_ACCOUNT = "Déjà inscrit ? Se connecter";
const String AUTH_LOGIN_SUCCESS = "Connexion réussie !";
const String AUTH_REGISTER_SUCCESS = "Compte créé avec succès !";
const String AUTH_LOGOUT_SUCCESS = "Vous avez été déconnecté.";
const String AUTH_PROFILE_TITLE = "Mon Profil";
const String AUTH_ROLE_TENANT = "Locataire";
const String AUTH_ROLE_LANDLORD = "Bailleur";
const String AUTH_ROLE_OWNER = "Propriétaire";
const String AUTH_FIELD_ROLE = "Rôle de l'utilisateur";
const String AUTH_EDIT_PROFILE_BUTTON = "Modifier le profil";
const String AUTH_EDIT_PROFILE_TITLE = "Modifier mon profil";
const String AUTH_SAVE_PROFILE_BUTTON = "Enregistrer les modifications";
const String AUTH_PROFILE_UPDATE_SUCCESS = "Profil mis à jour avec succès !";
const String AUTH_FIELD_PHONE_HINT = "+216 XX XXX XXX";
const String AUTH_NO_PHONE = "Non renseigné";
const String AUTH_MEMBER_SINCE = "Membre depuis";
const String AUTH_STATUS_VERIFIED = "Compte vérifié";
const String AUTH_MEMBERSHIP_DATE = "Membre depuis 2026";

// Actions & Themes
const String THEME_TOGGLE_TOOLTIP = "Basculer le thème clair / sombre";
const String ACTION_RETRY = "Réessayer";
const String ACTION_CANCEL = "Annuler";
const String ACTION_CONFIRM = "Confirmer";
const String ACTION_CLOSE = "Fermer";
const String ACTION_LOGIN = "Se connecter";

// Guest gates & prompts (Phase G2)
const String AUTH_CREATE_ACCOUNT_BUTTON = "Créer un compte";
const String FAVORITES_GUEST_SNACKBAR_MESSAGE = "Connectez-vous pour enregistrer vos favoris";
const String GUEST_SAVED_TITLE = "Retrouvez vos favoris partout";
const String GUEST_SAVED_SUBTITLE =
    "Connectez-vous à votre compte Sokna pour sauvegarder vos logements préférés et les synchroniser sur tous vos appareils.";
const String GUEST_POST_TITLE = "Publiez vos annonces immobilières";
const String GUEST_POST_SUBTITLE =
    "Connectez-vous ou créez un compte pour déposer une annonce de location et trouver des locataires vérifiés.";
const String GUEST_REVIEW_TITLE = "Partagez votre avis sur ce logement";
const String GUEST_REVIEW_SUBTITLE =
    "Connectez-vous à votre compte pour laisser une évaluation et aider la communauté Sokna.";

// Reviews section (Phase C2)
const String DETAIL_REVIEWS_TITLE = "Avis des locataires";
const String DETAIL_NO_REVIEWS = "Aucun avis pour le moment. Soyez le premier à donner votre avis !";
const String DETAIL_ADD_REVIEW_TITLE = "Laisser un avis";
const String DETAIL_REVIEW_RATING_LABEL = "Votre note";
const String DETAIL_REVIEW_COMMENT_LABEL = "Votre commentaire";
const String DETAIL_REVIEW_COMMENT_HINT = "Partagez votre expérience sur ce logement...";
const String DETAIL_REVIEW_SUBMIT_BUTTON = "Publier mon avis";
const String DETAIL_REVIEW_SUCCESS = "Votre avis a été publié avec succès !";
const String DETAIL_REVIEW_LOGIN_PROMPT = "Veuillez vous connecter pour laisser un avis.";
const String DETAIL_REVIEW_EMPTY_COMMENT = "Veuillez saisir un commentaire pour votre avis.";

// Guest Profile Screen (Phase G3)
const String PROFILE_GUEST_TITLE = "Mode Invité";
const String PROFILE_GUEST_SUBTITLE =
    "Vous consultez les annonces publiques en direct. Connectez-vous pour débloquer toutes les fonctionnalités.";
const String PROFILE_GUEST_FEATURE_FAVORITES = "Sauvegarder vos favoris sur le cloud";
const String PROFILE_GUEST_FEATURE_POST = "Publier et gérer vos annonces de location";
const String PROFILE_GUEST_FEATURE_REVIEWS = "Laisser des avis et noter les logements";



