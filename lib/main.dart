import 'package:climbnotes/constants/routes.dart';
import 'package:climbnotes/firebase_options.dart';
import 'package:climbnotes/services/auth/auth_service.dart';
import 'package:climbnotes/views/login_view.dart';
import 'package:climbnotes/views/notes_view.dart';
import 'package:climbnotes/views/register_view.dart';
import 'package:climbnotes/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import "dart:developer" as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 13, 22, 125)),
        // primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        registerRoute: (context) => const RegisterView(),
        loginRoute: (context) => const LoginView(),
        verifyRoute: (context) => const VerifyEmailView(),
        noteRoute: (context) => const NotesView()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}
