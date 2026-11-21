import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/favorites_repository.dart';

class ToggleSavedListingUseCase {
  final FavoritesRepository repository;

  ToggleSavedListingUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(String listingId) async {
    return await repository.toggleSavedListing(listingId);
  }
}
