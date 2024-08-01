import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFireBase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);

  void testing() {
    const AuthUser(isEmailVerified: true);
  }
}
