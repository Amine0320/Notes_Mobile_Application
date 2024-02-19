// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:notes_app/firebase_options.dart';
//import 'dart:developer' as devtools show log;

import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/utilities/show_error_log.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

//
  @override
  Widget build(BuildContext context) {
    // FIRST LOGIC
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Login'),
    //   ),
    //   body: FutureBuilder(
    //     future: Firebase.initializeApp(
    //       options: DefaultFirebaseOptions.currentPlatform,
    //     ),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else {
    //         return ;
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;

              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    NotesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    VerifyEmailRoute,
                    (route) => false,
                  );
                }
                // Change on notes app but not in kaisi test app ATTENTION !
              } on FirebaseAuthException catch (e) {
                if (e.code == 'usernot-found') {
                  await showErrorDialog(context, 'User not found');
                } else if (e.code == 'worng-password') {
                  await showErrorDialog(context, 'Wrong Password ');
                } else {
                  await showErrorDialog(context, 'Error${e.code}');
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RegisterRoute,
                  (route) => false,
                );
              },
              child: const Text('Not registred yet ? Register Me ! ')),
        ],
      ),
    );
  }
}

//         },
//       ),
//     );
//   }
// }
// ALERT WHILE ERROR OCCURED IN LOG IN
