import 'package:climbnotes/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "dart:developer" as devtool show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
          title: const Text("Login"),
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
                final userCred = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);

                devtool.log(userCred.toString());
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(noteRoute, (route) => false);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "invalid-credential") {
                  devtool.log("Invalid credentials provided");
                  if (context.mounted) {
                    showSnackBar(context, "wrong credentials");
                  }
                } else {
                  if (context.mounted) {
                    showSnackBar(context, e.code);
                  }
                  devtool.log(e.code);
                }
              } catch (e) {
                // devtool.log("something bad happened");
                if (context.mounted) {
                  showSnackBar(context, e.toString());
                }

                devtool.log(e.toString());
              }
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                    const Color.fromARGB(255, 59, 35, 115))),
            child: const Text(
              "Login",
              style: TextStyle(color: Color.fromARGB(225, 225, 225, 225)),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not registered yet, click here to sign up")),
        ],
      ),
    );
  }
}

ScaffoldFeatureController<Widget, SnackBarClosedReason> showSnackBar(
    BuildContext context, String content) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content)));
}
