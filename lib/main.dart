import 'package:flutter/material.dart';
import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/exceptions/auth/auth_service.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';
//import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
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
// LOGIC
// HomePage STL
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().intialize(),
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
          final user = AuthService.firebase().currentUser;
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
                  if (user.isEmailVerified) {
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
