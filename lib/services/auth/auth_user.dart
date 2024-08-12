import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;
  const AuthUser(
      {required this.id, required this.isEmailVerified, required this.email});

  factory AuthUser.fromFireBase(User user) => AuthUser(
      id: user.uid, isEmailVerified: user.emailVerified, email: user.email!);

  // void testing() {
  //   const AuthUser(isEmailVerified: true);
  // }
}
