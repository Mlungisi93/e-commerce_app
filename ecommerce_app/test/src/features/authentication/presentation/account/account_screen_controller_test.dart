import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      final authRepository = MockAuthRepository();
      final controller = AccountScreenController(
        authRepository: authRepository,
      );
      verifyNever(authRepository.signOut);
      expect(controller.state, const AsyncData<void>(null));
    });

    test('signOut success', () async {
      // setup
      final authRepository = MockAuthRepository();
      /*By default, mocks implement all methods by returning null.

Stubbing a mock
We can stub a mock to decide the response of a mock method. Example: */
      when(authRepository.signOut).thenAnswer(
        (_) => Future.value(),
      );
      final controller = AccountScreenController(
        authRepository: authRepository,
      );
      // run
      await controller.signOut();
      // verify
      verify(authRepository.signOut).called(1);
      expect(controller.state, const AsyncData<void>(null));
    });

    test('signOut failure', () async {
      // setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      final controller = AccountScreenController(
        authRepository: authRepository,
      );
      // run
      await controller.signOut();
      // verify
      verify(authRepository.signOut).called(1);
      expect(controller.state.hasError,
          true); //verify that only error without Staketrace
      expect(controller.state, isA<AsyncError>());
      // expect(controller.state, AsyncError<void>(exception, StackTrace.empty));

      ////this fails because syncValue.guard(() throws both error and Stacktrace(while we were expection stacktrace to be null but actually is not null)
      //matchers
    });
  });
}
