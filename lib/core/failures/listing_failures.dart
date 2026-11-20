import 'failures.dart';

class ListingNotFoundFailure extends Failure {
  const ListingNotFoundFailure([super.message = 'Logement introuvable']);
}

class EmptyListingFailure extends Failure {
  const EmptyListingFailure([super.message = 'Aucun logement disponible']);
}
