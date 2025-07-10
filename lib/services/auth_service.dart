import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(String email, String password, String name) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user profile with name
      await credential.user?.updateDisplayName(name);

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Please enter a valid email address.');
      } else if (e.code == 'operation-not-allowed') {
        throw Exception('Email/password accounts are not enabled.');
      } else {
        throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      print('Error during sign up: $e');
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Please enter a valid email address.');
      } else if (e.code == 'user-disabled') {
        throw Exception('This account has been disabled.');
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('Error during sign in: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error sending password reset email: ${e.message}');
      throw Exception('Failed to send reset email: ${e.message}');
    } catch (e) {
      print('Error sending password reset email: $e');
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }

  // Delete account
  Future<bool> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Error deleting account: ${e.message}');
      throw Exception('Failed to delete account: ${e.message}');
    } catch (e) {
      print('Error deleting account: $e');
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  // Check if email is verified
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  // Send email verification
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print('Error sending email verification: ${e.message}');
      throw Exception('Failed to send verification email: ${e.message}');
    } catch (e) {
      print('Error sending email verification: $e');
      throw Exception('Failed to send verification email: ${e.toString()}');
    }
  }
}