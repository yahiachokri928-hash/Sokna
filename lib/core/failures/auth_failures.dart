import '../strings/failures.dart';
import 'failures.dart';

class RegisterUserWeakPwdFailure extends Failure {
  const RegisterUserWeakPwdFailure([super.message = AUTH_WEAK_PASSWORD_MESSAGE]);
}

class RegisterUserUsedEmailFailure extends Failure {
  const RegisterUserUsedEmailFailure([super.message = AUTH_EMAIL_ALREADY_IN_USE_MESSAGE]);
}

class SignInUserNotFoundFailure extends Failure {
  const SignInUserNotFoundFailure([super.message = AUTH_USER_NOT_FOUND_MESSAGE]);
}

class SignInWrongPwdFailure extends Failure {
  const SignInWrongPwdFailure([super.message = AUTH_WRONG_PASSWORD_MESSAGE]);
}

// Aliases and additional failures
class AuthUserNotFoundFailure extends SignInUserNotFoundFailure {
  const AuthUserNotFoundFailure([super.message = AUTH_USER_NOT_FOUND_MESSAGE]);
}

class AuthWrongPasswordFailure extends SignInWrongPwdFailure {
  const AuthWrongPasswordFailure([super.message = AUTH_WRONG_PASSWORD_MESSAGE]);
}

class AuthEmailAlreadyInUseFailure extends RegisterUserUsedEmailFailure {
  const AuthEmailAlreadyInUseFailure([super.message = AUTH_EMAIL_ALREADY_IN_USE_MESSAGE]);
}

class AuthWeakPasswordFailure extends RegisterUserWeakPwdFailure {
  const AuthWeakPasswordFailure([super.message = AUTH_WEAK_PASSWORD_MESSAGE]);
}

class AuthInvalidEmailFailure extends Failure {
  const AuthInvalidEmailFailure([super.message = AUTH_INVALID_EMAIL_MESSAGE]);
}

class AuthNetworkRequestFailedFailure extends Failure {
  const AuthNetworkRequestFailedFailure([super.message = AUTH_NETWORK_REQUEST_FAILED_MESSAGE]);
}

class AuthUnknownFailure extends Failure {
  const AuthUnknownFailure([super.message = UNEXPECTED_FAILURE_MESSAGE]);
}
