sealed class Failure {
  const Failure(this.message);

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Unable to connect. Check your network and try again.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'The server returned an unexpected error.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Your session has expired. Please sign in again.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Please check the highlighted fields.',
  ]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Unable to read local data.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'The requested item could not be found.',
  ]);
}
