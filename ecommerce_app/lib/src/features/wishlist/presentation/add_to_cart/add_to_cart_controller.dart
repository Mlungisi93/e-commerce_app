import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wish_list_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToWishListController extends StateNotifier<AsyncValue<int>> {
  AddToWishListController({required this.wishListService})
      : super(const AsyncData(1));
  final WishListService wishListService;

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }

  Future<void> addItem(ProductID productId) async {
    final item = Item(productId: productId, quantity: state.value!);
    state = const AsyncLoading<int>().copyWithPrevious(state);
    final value = await AsyncValue.guard(() => wishListService.addItem(item));
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(1);
    }
  }
}

final addToWishListControllerProvider =
    StateNotifierProvider.autoDispose<AddToWishListController, AsyncValue<int>>(
        (ref) {
  return AddToWishListController(
    wishListService: ref.watch(wishListServiceProvider),
  );
});
