import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  // Aadded email in parameters but not in Kaisi Test App Warning !
  final String? email;
  const AuthUser({required this.email, required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
  reload() {}
}
