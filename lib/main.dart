import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      // Route of the application
      routes: {
        LoginRoute: (context) => const LoginView(),
        RegisterRoute: (context) => const RegisterView(),
        NotesRoute: (context) => const NotesView(),
      },
    ),
  );
}

// Connection state
// enum ConnectionState {
//   Connected,
//   Disconnected,
//   Connecting,
// }

// HomePage STL
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Error handling
          return const Center(
            child: Text('Error'),
          );
        } else {
          final user = snapshot.data;
          if (user != null) {
            return FutureBuilder<void>(
              future: user.reload(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading indicator while user data is being refreshed
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (user.emailVerified) {
                    return const NotesView();
                  } else {
                    return const VerifyEmailView();
                  }
                }
              },
            );
          } else {
            return const LoginView();
          }
        }
      },
    );
  }
}

enum MenuAction { logout }
// Notes View !

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main UI'),
          // Interface for logout item from popopmenuitem
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final ShouldLogOut = await showLogOutDialog(context);
                    // devtools.log(ShouldLogOut.toString());
                    if (ShouldLogOut) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginRoute,
                        (route) => false,
                      );
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Log Out')),
                ];
              },
            )
          ],
        ),
        body: const Text('Hello World ! '));
  }
}

// SHOWLOGOUT DIALOG FUNCTION POPOUT LOGIC INTERFACE HERE
Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to sign out ?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
          ]);
    },
  ).then((value) => value ?? false);
}
