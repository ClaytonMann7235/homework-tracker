import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return _authErrorMessage(error, isSigningUp: false);
    } catch (_) {
      return 'Unable to log in right now. Please try again.';
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (error) {
      return _authErrorMessage(error, isSigningUp: true);
    } catch (_) {
      return 'Unable to create your account right now. Please try again.';
    }
  }

  String _authErrorMessage(
    FirebaseAuthException error, {
    required bool isSigningUp,
  }) {
    switch (error.code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'email-already-in-use':
        return 'An account already uses this email. Try signing in instead.';
      case 'weak-password':
        return 'Choose a stronger password.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment and try again.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'operation-not-allowed':
        return isSigningUp
            ? 'Email sign-up is not enabled. Contact support.'
            : 'Email sign-in is not enabled. Contact support.';
      default:
        return isSigningUp
            ? 'Unable to create your account right now. Please try again.'
            : 'Unable to log in right now. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

}