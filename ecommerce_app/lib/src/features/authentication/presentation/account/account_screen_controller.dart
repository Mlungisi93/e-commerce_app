import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController({required this.authRepository})
      : super(const AsyncValue<void>.data(null));
  final FakeAuthRepository authRepository;

  Future<void> signOut() async {
    // set state to loading
    // sign out (using auth repository)
    // if success, set state to data
    // if error, set state to error
    // try {
    //   state = const AsyncValue<void>.loading();
    //   await authRepository.signOut();
    //   state = const AsyncValue<void>.data(null);
    //   return true;
    // } catch (e, st) {
    //   state = AsyncValue<void>.error(e, st);
    //   return false;
    // }
    //simplyfying the above to avoid try catch block suing guard
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authRepository.signOut());
    state.hasError == false;
  }
}

final accountScreenControllerProvider =
    StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(
    authRepository: authRepository,
  );
});
