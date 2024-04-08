import 'package:flutter/foundation.dart' show immutable;
import 'package:notes_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a minute ',
  });
}

class AuthStateOnIntialized extends AuthState {
  const AuthStateOnIntialized({
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? execption;
  const AuthStateRegistering({
    required isLoading,
    required this.execption,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required bool isLoading,
    required this.user,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;
  const AuthStateForgotPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    required String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}
