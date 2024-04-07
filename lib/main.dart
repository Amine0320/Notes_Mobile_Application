import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/services/auth/firebase_auth_provider.dart';
import 'package:notes_app/utilities/dialogs/loading_dialog.dart';
import 'package:notes_app/views/Authentification/login_view.dart';
import 'package:notes_app/views/Authentification/register_view.dart';
import 'package:notes_app/views/Authentification/verify_email_view.dart';
import 'package:notes_app/views/notes/create_update_note_view.dart';
import 'package:notes_app/views/notes/notes_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      // Route of the application
      routes: {
        newNoteRoute: (context) => const NewNoteView(),
      },
    ),
  );
}

//LOGIC NEED TO IMPLEMENT INTO KAISI TEST APP
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventIntialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please Wait  a moment ! ',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
    // return FutureBuilder(
    //   future: AuthService.firebase().intialize(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // Loading indicator
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (snapshot.hasError) {
    //       // Error handling
    //       return const Center(
    //         child: Text('Error'),
    //       );
    //     } else {
    //       final user = AuthService.firebase().currentUser;
    //       if (user != null) {
    //         return FutureBuilder<void>(
    //           future: user.reload(),
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               // Loading indicator while user data is being refreshed
    //               return const Center(
    //                 child: CircularProgressIndicator(),
    //               );
    //             } else {
    //               if (user.isEmailVerified) {
    //                 return const NotesView();
    //               } else {
    //                 return const VerifyEmailView();
    //               }
    //             }
    //           },
    //         );
    //       } else {
    //         return const LoginView();
    //       }
    //     }
    //   },
    // );
  }
}
