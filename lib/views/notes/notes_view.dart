import 'package:climbnotes/constants/routes.dart';
import 'package:climbnotes/enums/menu_action.dart';
import 'package:climbnotes/services/auth/auth_service.dart';
import 'package:climbnotes/services/crud/crudnote_service.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NoteService _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _noteService = NoteService();
    // _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        backgroundColor: const Color.fromARGB(255, 195, 207, 98),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, loginRoute, (_) => false);
                      }
                    }
                    // devtools.log(shouldLogout.toString());
                    break;
                  default:
                }
                // devtools.log("logged out already");
              },
              itemBuilder: (context) => const [
                    PopupMenuItem<MenuAction>(
                        value: MenuAction.logout, child: Text("Log out")
                        // IconButton(
                        //   onPressed: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text("Logged out")));
                        //   },
                        //   icon: const Icon(Icons.logout_rounded),
                        //   tooltip: "Logout",
                        // )
                        )
                  ]),
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _noteService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text("Waiting for all notes");

                      default:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  });
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Log out"),
          content: const Text("Do you want to log out"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Logout"),
            )
          ],
        );
      }).then((value) => value ?? false);
}
