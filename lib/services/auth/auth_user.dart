import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  // Aadded email in parameters but not in Kaisi Test App Warning !
  final String email;
  const AuthUser(
      {required this.id, required this.email, required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
  reload() {}
}
