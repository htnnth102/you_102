import 'package:your/pages/domain/data_source/firebase_auth_service.dart';

abstract class AuthenticationRepository {
  Future<void> loginWithCredentials({
    required String email,
    required String password,
  });
}

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  late final FirebaseAuthService firebaseAuthService;

  AuthenticationRepositoryImpl({required this.firebaseAuthService});

  @override
  Future<void> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuthService.loginWithCredentials(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
