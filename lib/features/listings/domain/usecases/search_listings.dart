import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/listing_entity.dart';
import '../repositories/listing_repository.dart';

class SearchListingsUseCase {
  final ListingRepository repository;

  SearchListingsUseCase(this.repository);

  Future<Either<Failure, List<ListingEntity>>> call(String query) async {
    return await repository.searchListings(query);
  }
}
