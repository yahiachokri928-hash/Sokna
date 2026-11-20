import 'failures.dart';

class AuthUserNotFoundFailure extends Failure {
  const AuthUserNotFoundFailure([super.message = 'Aucun utilisateur trouvé']);
}

class AuthWrongPasswordFailure extends Failure {
  const AuthWrongPasswordFailure([super.message = 'Mot de passe incorrect']);
}

class AuthEmailAlreadyInUseFailure extends Failure {
  const AuthEmailAlreadyInUseFailure([super.message = 'Adresse e-mail déjà utilisée']);
}

class AuthWeakPasswordFailure extends Failure {
  const AuthWeakPasswordFailure([super.message = 'Mot de passe trop faible']);
}

class AuthInvalidEmailFailure extends Failure {
  const AuthInvalidEmailFailure([super.message = 'Adresse e-mail invalide']);
}

class AuthNetworkRequestFailedFailure extends Failure {
  const AuthNetworkRequestFailedFailure([super.message = 'Erreur réseau']);
}

class AuthUnknownFailure extends Failure {
  const AuthUnknownFailure([super.message = 'Erreur d\'authentification']);
}
