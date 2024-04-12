import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
// import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invaild email');
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Register View !')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Enter your email and password to see your notes !'),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    autocorrect: false,
                    autofocus: true,
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    autocorrect: false,
                    autofocus: true,
                    enableSuggestions: false,
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          context.read<AuthBloc>().add(AuthEventRegister(
                                email,
                                password,
                              ));
                          // try {
                          //   await AuthService.firebase().createUser(
                          //     email: email,
                          //     password: password,
                          //   );
                          // AuthService.firebase().sendEmailVerification();
                          // Navigating to verify email view
                          // Navigator.of(context).pushNamed(verifyEmailRoute);
                          //   }
                          //   on WeakPasswordAuthException {
                          //     await showErrorDialog(context, 'Weak password');
                          //   } on EmailAlreadyInUseAuthException {
                          //     await showErrorDialog(context, 'Email already in user');
                          //   } on InvalidEmailAuthException {
                          //     await showErrorDialog(context, 'Invalid email address');
                          //   } on GenericAuthException {
                          //     await showErrorDialog(context, "Failed to register");
                          //   }
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            // Navigator.of(context).pushNamedAndRemoveUntil(
                            //   loginRoute,
                            //   (route) => false,
                            // );
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventLogOut());
                          },
                          child: const Text(
                              'Already Registered ? Login Here !  ')),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
//
