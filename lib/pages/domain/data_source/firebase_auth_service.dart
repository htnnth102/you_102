import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  Future<void> loginWithCredentials({
    required String email,
    required String password,
  }) async {
    try {
      // Your login logic here
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
