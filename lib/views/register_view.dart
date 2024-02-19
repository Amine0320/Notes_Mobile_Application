// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:notes_app/firebase_options.dart';
import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/utilities/show_error_log.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Register'),
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
    //         return
    return Scaffold(
        appBar: AppBar(title: Text('Register View !')),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  // Navigating to verify email view
                  Navigator.of(context).pushNamed(VerifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showErrorDialog(context, 'Weak password');
                  } else if (e.code == 'email-already-in-use') {
                    showErrorDialog(context, 'Email already in user');
                  } else if (e.code == 'invalid-email') {
                    showErrorDialog(context, 'Invalid email address');
                  } else {
                    await showErrorDialog(context, e.toString());
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Already Registered ? Login Here !  '))
          ],
        ));
  }
}
//
