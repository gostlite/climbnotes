import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;
  const AuthUser({required this.isEmailVerified, required this.email});

  factory AuthUser.fromFireBase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified, email: user.email);

  // void testing() {
  //   const AuthUser(isEmailVerified: true);
  // }
}
