import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthInitialize extends AuthEvent {}

class SignInWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterWithEmailPassword extends AuthEvent {
  final String email;
  final String password;

  const RegisterWithEmailPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogle extends AuthEvent {}

class SignOut extends AuthEvent {}
