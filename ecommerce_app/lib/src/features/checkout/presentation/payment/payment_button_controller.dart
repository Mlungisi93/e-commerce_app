import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentButtonController extends StateNotifier<AsyncValue<void>> {
  PaymentButtonController({required this.fakeCheckoutService})
      : super(const AsyncData(null));
  final FakeCheckoutService fakeCheckoutService;
  Future<void> pay() async {
    state = await AsyncLoading();
    // state = await AsyncValue.guard(() => fakeCheckoutService.placeOrder());
    state = await AsyncValue.guard(
        fakeCheckoutService.placeOrder); // method tear-off
  }
}

final paymentButtonControllerProvider =
    StateNotifierProvider<PaymentButtonController, AsyncValue<void>>((ref) {
  return PaymentButtonController(
      fakeCheckoutService: ref.watch(checkoutServiceProvider));
});
