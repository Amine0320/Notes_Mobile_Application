import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:notes_app/contants/routes.dart';
// import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Column(
        children: [
          const Text(
              "We've already sent you an email verification . Please open it to verify your account "),
          const Text("If you haven't recieve a verification email"),
          TextButton(
              onPressed: () async {
                // await AuthService.firebase().sendEmailVerification();
                // converting to AuthBloc
                context
                    .read<AuthBloc>()
                    .add(const AuthEvenSendEmailVerification());
              },
              child: const Text('send email verification ! ')),
          TextButton(
              onPressed: () async {
                // await AuthService.firebase().logOut();
                //   Navigator.of(context)
                //       .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                // converting to AuthBloc
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
