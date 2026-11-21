import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/listing_repository.dart';

class DeleteListingUseCase {
  final ListingRepository repository;

  DeleteListingUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String listingId) async {
    return await repository.deleteListing(listingId);
  }
}
