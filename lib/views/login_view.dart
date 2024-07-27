import 'package:climbnotes/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                // TODO: Handle this case.
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          hintText: "Enter your Email here"),
                    ),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: const InputDecoration(
                          hintText: "Enter your password here"),
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCred = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);

                          print(userCred);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "invalid-credential") {
                            print("Invalid credentials provided");
                          } else {
                            print("something bad happeed");
                            print(e.code);
                          }
                        } catch (e) {
                          print("something bad happened");

                          print(e);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 59, 35, 115))),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromARGB(225, 225, 225, 225)),
                      ),
                    ),
                  ],
                );
              default:
                return const Icon(Icons.rocket_rounded);
            }
          },
        ));
  }
}
