import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes_app/contants/routes.dart';
import 'package:notes_app/services/auth/auth_exceptions.dart';
// import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException ||
              state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'User-not-found');
          }
          // else if (state.exception is WrongPasswordAuthException) {
          //   await showErrorDialog(context, 'Wrong crendetials');
          // }
          else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentification Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
            ),
            TextButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;

                // await AuthService.firebase().logIn(
                //   email: email,
                //   password: password,
                // );
                // final user = AuthService.firebase().currentUser;
                // if (user?.isEmailVerified ?? false) {
                //   Navigator.of(context).pushNamedAndRemoveUntil(
                //     notesRoute,
                //     (route) => false,
                //   );
                // } else {
                //   Navigator.of(context).pushNamedAndRemoveUntil(
                //     verifyEmailRoute,
                //     (route) => false,
                //   );
                // }
                context.read<AuthBloc>().add(AuthEventLogIn(
                      email,
                      password,
                    ));
                // Change on notes app but not in kaisi test app ATTENTION !
                //   } on UserNotFoundAuthException {
                //     await showErrorDialog(context, 'User not found');
                //   } on WrongPasswordAuthException {
                //     await showErrorDialog(context, 'Wrong Password ');
                //   } on GenericAuthException {
                //     await showErrorDialog(context, 'Authentification Error');
                //   }
              },
              child: const Text('Login'),
              // ),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text('I forgot my password  ')),
            TextButton(
                onPressed: () {
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   registerRoute,
                  //   (route) => false,
                  // );
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text('Not registred yet ? Register Me ! ')),
          ],
        ),
      ),
    );
  }
}

//         },
//       ),
//     );
//   }
// }
