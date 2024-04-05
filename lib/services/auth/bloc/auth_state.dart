import 'package:flutter/foundation.dart' show immutable;
import 'package:notes_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateOnIntialized extends AuthState {
  const AuthStateOnIntialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? execption;
  const AuthStateRegistering(this.execption);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({required this.exception, required this.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}
