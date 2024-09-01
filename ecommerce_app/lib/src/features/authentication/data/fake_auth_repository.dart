import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/in_memory_store.dart';
import '../domain/app_user.dart';
//Creating repositories using abstract classes (optional)
// If desired, we can define a base abstract class for our AuthRepository:
//
// abstract class AuthRepository {
//   Stream<AppUser?> authStateChanges();
//   AppUser? get currentUser;
//   Future<void> signInWithEmailAndPassword(String email, String password);
//   Future<void> createUserWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
// }
//Creating repositories using abstract classes (optional)
// If desired, we can define a base abstract class for our AuthRepository:
//
// abstract class AuthRepository {
//   Stream<AppUser?> authStateChanges();
//   AppUser? get currentUser;
//   Future<void> signInWithEmailAndPassword(String email, String password);
//   Future<void> createUserWithEmailAndPassword(String email, String password);
//   Future<void> signOut();
// }
///And we can modify our provider to choose which repository to return based on some environment variable:
//
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   // Run with this command:
//   // flutter run --dart-define=useFakeRepos=true/false
//   final isFake = String.fromEnvironment('useFakeRepos') == 'true';
//   return isFake ? FakeAuthRepository() : FirebaseAuthRepository();
// });

/// {@template fake_auth_repository}
/// A fake implementation of [AuthRepository] for testing and development.
/// {@endtemplate}
class FakeAuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  /// Returns a stream of [AppUser] to represent the authentication state.
  ///
  /// {@template fake_auth_state_changes}
  /// TODO: Update to emitactual authentication state changes.
  /// {@endtemplate}
  Stream<AppUser?> authStateChanges() => _authState.stream;

  /// Returns the currently authenticated [AppUser], or `null` if no user is
  /// signed in.
  ///
  /// {@template fake_current_user}
  /// TODO: Update to return the actual current user.
  /// {@endtemplate}
  AppUser? get currentUser => _authState.value;

  /// Signs in a user with the given email and password.
  ///
  /// {@template fake_sign_in_with_email_and_password}
  /// TODO: Implement actual sign-in logic.
  /// {@endtemplate}
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // TODO: Implement
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  /// Creates a new user with the given email and password.
  ///
  /// {@template fake_create_user_with_email_and_password}
  /// TODO: Implement actual user creation logic.
  /// {@endtemplate}
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    if (currentUser == null) {
      _createNewUser(email);
    }
  }

  /// Signs out the current user.
  ///
  /// {@template fake_sign_out}
  /// TODO: Implement actual sign-out logic.
  /// {@endtemplate}
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 3));
    throw Exception('Connection failed');
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(String email) {
    _authState.value = AppUser(
      uid: email.split('').reversed.join(),
      email: email,
    );
  }
}

/// Provides a [FakeAuthRepository] instance.
///
/// {@template auth_repository_provider}
/// This provider is used for testing and development purposes.
/// {@endtemplate}
final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  final auth = FakeAuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
});

/// Provides a stream of [AppUser] to represent the authentication state.
///
/// {@template auth_state_changes_provider}
/// This provider listens to the [authStateChanges] stream from the
/// [authRepositoryProvider] and emits the current authentication state.
/// {@endtemplate}
final authStateChangesProvider = StreamProvider.autoDispose<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
