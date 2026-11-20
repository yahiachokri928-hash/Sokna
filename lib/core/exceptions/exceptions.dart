class ServerException implements Exception {
  final String? message;
  const ServerException([this.message]);
}

class OfflineException implements Exception {
  final String? message;
  const OfflineException([this.message]);
}

class CacheException implements Exception {
  final String? message;
  const CacheException([this.message]);
}

class EmptyListException implements Exception {
  final String? message;
  const EmptyListException([this.message]);
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}
