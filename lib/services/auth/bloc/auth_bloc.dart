import 'package:bloc/bloc.dart';
import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateOnIntialized(isLoading: true)) {
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        isLoading: false,
        execption: null,
      ));
    });
    //send email verification
    // attention not to handle in Kaisi App
    on<AuthEvenSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(isLoading: false, execption: e));
      }
    });
    //initialize
    on<AuthEventIntialize>((event, emit) async {
      await provider.intialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
          loadingText: 'Please Wait while i log you in ',
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(isLoading: false, user: user));
      }
    });
    // log in
    on<AuthEventLogIn>((event, emit) async {
      // emit(const AuthStateLoading());
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
        loadingText: '',
      ));
      // await Future.delayed(const Duration(seconds: 3));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
            loadingText: 'Please Wait while i log you in',
          ));
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
            loadingText: 'Please Wait while i log you in',
          ));
          emit(AuthStateLoggedIn(isLoading: false, user: user));
        }
        emit(AuthStateLoggedIn(isLoading: false, user: user));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
            exception: e,
            isLoading: false,
            loadingText: 'Please Wait while i log you in'));
      }
    });
    //forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot-password screen
      }

      // user wants to actually send a forgot-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
          loadingText: '',
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
          loadingText: '',
        ));
      }
    });
  }
}
