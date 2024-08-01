import 'dart:math';

import 'package:climbnotes/services/auth/auth_exceptions.dart';
import 'package:climbnotes/services/auth/auth_provider.dart';
import 'package:climbnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Authentication Description", () {
    final provider = MockAuthProvider();
    test("Should be initialized to begin with", () {
      expect(provider._isInitialized, false);
    });
    test("Should not log out except initialized", () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test("Should be able to Initialize", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test("User must be null after initialization", () {
      expect(provider.currentUser, null);
    });
    test("should be initialized in less than 3 sec", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 3)));
    test("Create User should delagate login function", () async {
      final badEmailUser = provider.createUser(
          email: "foobar@gmail.com", password: "passwprd123");
      expect(badEmailUser, throwsA(const TypeMatcher<UserNotFoundException>()));

      final user = await provider.createUser(email: "foo", password: "bar");
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test("Login User should be able to get verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test("Should be able to log out and log in again", () async {
      await provider.logOut();
      await provider.logIn(email: "email", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 2));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foobar@gmail.com") throw UserNotFoundException();
    if (password == "password123") throw WrongCredentialsException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return await Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 2));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
