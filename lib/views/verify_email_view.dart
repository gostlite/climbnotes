import 'package:climbnotes/constants/routes.dart';
import 'package:climbnotes/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Verify Email"),
          backgroundColor: const Color.fromARGB(224, 104, 42, 42)),
      body: Column(
        children: [
          const Text(
              "A verification email has been sent to you, check your email to verify"),
          const Text(
              "if you've not received a verication email, click the button below"),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                if (context.mounted) {
                  showSnackBar(context, "go to your email to verify");
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => true);
                }
              },
              child: const Text("Send Email Verification")),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => true);
                }
              },
              child: const Text("Restart registration"))
        ],
      ),
    );
  }
}
