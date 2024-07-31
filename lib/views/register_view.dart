// import 'package:climbnotes/firebase_options.dart';
import 'package:climbnotes/constants/routes.dart';
import 'package:climbnotes/services/auth/auth_exceptions.dart';
import 'package:climbnotes/services/auth/auth_service.dart';
import 'package:climbnotes/utilities/showerror_dialog.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import "dart:developer" as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Register"),
          backgroundColor: const Color.fromARGB(224, 104, 42, 42)),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: "Enter your Email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: "Enter your password here"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();

                if (context.mounted) {
                  Navigator.of(context).pushNamed(verifyRoute);
                }
              } on EmailAlreadyInUseException catch (_) {
                if (context.mounted) {
                  showSnackBar(context, "This user already exists");
                }
              } on WeakPasswordException catch (_) {
                if (context.mounted) {
                  showSnackBar(context, "Password is Weak");
                }
              } on InvalidEmailException catch (_) {
                if (context.mounted) {
                  showSnackBar(context, "Invalid email");
                }
              } on GenericAuthException catch (_) {
                if (context.mounted) {
                  showSnackBar(context, "An error Occured");
                }
              }
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 59, 35, 115))),
            child: const Text(
              "Register",
              style: TextStyle(color: Color.fromARGB(225, 225, 225, 225)),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Do you have an account? Login here"))
        ],
      ),
    );
  }
}
