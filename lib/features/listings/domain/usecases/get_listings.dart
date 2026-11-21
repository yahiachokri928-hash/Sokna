import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/listing_entity.dart';
import '../repositories/listing_repository.dart';

class GetListingsUseCase {
  final ListingRepository repository;

  GetListingsUseCase(this.repository);

  Future<Either<Failure, List<ListingEntity>>> call() async {
    return await repository.getListings();
  }
}
