import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erreur serveur']);
}

class OfflineFailure extends Failure {
  const OfflineFailure([super.message = 'Aucune connexion Internet']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erreur de cache']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Erreur inattendue']);
}
