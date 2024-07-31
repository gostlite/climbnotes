import "package:climbnotes/firebase_options.dart";
import "package:climbnotes/services/auth/auth_exceptions.dart";
import "package:climbnotes/services/auth/auth_user.dart";
import "package:climbnotes/services/auth/auth_provider.dart";
import "package:firebase_auth/firebase_auth.dart"
    show FirebaseAuth, FirebaseAuthException;
import "package:firebase_core/firebase_core.dart";

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      sendEmailVerification();
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
    // throw UserNotFoundException();
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFireBase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFoundException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        throw WrongCredentialsException();
      } else if (e.code == "user-not-found") {
        throw UserNotFoundException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotFoundException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
