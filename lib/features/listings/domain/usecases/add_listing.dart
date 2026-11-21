import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/listing_entity.dart';
import '../repositories/listing_repository.dart';

class AddListingUseCase {
  final ListingRepository repository;

  AddListingUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ListingEntity listing) async {
    return await repository.addListing(listing);
  }
}
