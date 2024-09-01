import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/app_user.dart';

/// {@template fake_auth_repository}
/// A fake implementation of [AuthRepository] for testing and development.
/// {@endtemplate}
class FakeAuthRepository {
  /// {@macro fake_auth_repository}
  FakeAuthRepository();

  /// Returns a stream of [AppUser] to represent the authentication state.
  ///
  /// {@template fake_auth_state_changes}
  /// TODO: Update to emitactual authentication state changes.
  /// {@endtemplate}
  Stream<AppUser?> authStateChanges() => Stream.value(null);

  /// Returns the currently authenticated [AppUser], or `null` if no user is
  /// signed in.
  ///
  /// {@template fake_current_user}
  /// TODO: Update to return the actual current user.
  /// {@endtemplate}
  AppUser? get currentUser => null;

  /// Signs in a user with the given email and password.
  ///
  /// {@template fake_sign_in_with_email_and_password}
  /// TODO: Implement actual sign-in logic.
  /// {@endtemplate}
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    // TODO: Implement
  }

  /// Creates a new user with the given email and password.
  ///
  /// {@template fake_create_user_with_email_and_password}
  /// TODO: Implement actual user creation logic.
  /// {@endtemplate}
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    // TODO: Implement
  }

  /// Signs out the current user.
  ///
  /// {@template fake_sign_out}
  /// TODO: Implement actual sign-out logic.
  /// {@endtemplate}
  Future<void> signOut() async {
    // TODO: Implement
  }
}

/// Provides a [FakeAuthRepository] instance.
///
/// {@template auth_repository_provider}
/// This provider is used for testing and development purposes.
/// {@endtemplate}
final authRepositoryProvider = Provider<FakeAuthRepository>((ref) {
  return FakeAuthRepository();
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