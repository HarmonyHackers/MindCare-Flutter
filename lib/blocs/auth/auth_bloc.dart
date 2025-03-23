import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthInitialize>(_onAuthInitialize);
    on<SignInWithEmailPassword>(_onSignInWithEmailPassword);
    on<RegisterWithEmailPassword>(_onRegisterWithEmailPassword);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
  }

  Future<void> _onAuthInitialize(
      AuthInitialize event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // First check if there's a Firebase user
      if (_authService.currentUser != null) {
        final UserModel user = UserModel(
          uid: _authService.currentUser!.uid,
          email: _authService.currentUser!.email ?? '',
          displayName: _authService.currentUser!.displayName,
          photoURL: _authService.currentUser!.photoURL,
        );
        emit(Authenticated(user));
      } else {
        // If no Firebase user, try to get from SharedPreferences
        final UserModel? user = await UserPreferences.getUser();
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithEmailPassword(
      SignInWithEmailPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final UserModel? user = await _authService.signInWithEmailPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to sign in'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterWithEmailPassword(
      RegisterWithEmailPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final UserModel? user = await _authService.registerWithEmailPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to register'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final UserModel? user = await _authService.signInWithGoogle();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(const AuthError('Failed to sign in with Google'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
