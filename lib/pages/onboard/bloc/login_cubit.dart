import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your/pages/domain/authentication_repository.dart';

part 'login_state.dart'; // Indicate that `login_state.dart` is a part of this file

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository authenticationRepository;
  LoginCubit({
    required this.authenticationRepository,
  }) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    try {
      await authenticationRepository.loginWithCredentials(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
