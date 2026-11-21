import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/favorites_repository.dart';

class GetSavedListingIdsUseCase {
  final FavoritesRepository repository;

  GetSavedListingIdsUseCase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getSavedListingIds();
  }
}
