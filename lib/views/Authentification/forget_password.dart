import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/utilities/dialogs/error_dialog.dart';
import 'package:notes_app/utilities/dialogs/reset_password_dialog.dart';

// class ForgotPasswordView extends StatefulWidget {
//   const ForgotPasswordView({Key? key}) : super(key: key);

//   @override
//   _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
// }

// class _ForgotPasswordViewState extends State<ForgotPasswordView> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) async {
//         if (state is AuthStateForgotPassword) {
//           if (state.hasSentEmail) {
//             _controller.clear();
//             await showPasswordResetSentDialog(context);
//           }
//           if (state.exception != null) {
//             await showErrorDialog(
//               context,
//               "We could not process your request , please try again ",
//             );
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('forgot password'),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Text(
//                   "If you forget password simly enter your email and we will send you a reset link ",
//                 ),
//                 TextField(
//                   keyboardType: TextInputType.emailAddress,
//                   autocorrect: false,
//                   autofocus: true,
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: "Your email address",
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     final email = _controller.text;
//                     context
//                         .read<AuthBloc>()
//                         .add(AuthEventForgotPassword(email: email));
//                   },
//                   child: const Text(
//                     "send me password reset link ",
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     context.read<AuthBloc>().add(
//                           const AuthEventLogOut(),
//                         );
//                   },
//                   child: const Text(
//                     "Back to login page ",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              "We could not process your request , please try again ",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
              "If you forget password simly enter your email and we will send you a reset link "),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'forgot password',
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Your email address",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: const Text(
                    "send me password reset link ",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: const Text(
                    "Back to login page ",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
