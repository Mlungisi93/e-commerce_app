import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wish_list_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListScreenController extends StateNotifier<AsyncValue<void>> {
  WishListScreenController({required this.wishListService})
      : super(const AsyncData(null));
  final WishListService wishListService;

  Future<void> updateItemQuantity(ProductID productId, int quantity) async {
    state = const AsyncLoading();
    final updated = Item(productId: productId, quantity: quantity);
    state = await AsyncValue.guard(() => wishListService.setItem(updated));
  }

  Future<void> removeItemById(ProductID productId) async {
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => wishListService.removeItemById(productId));
  }
}

final wishListScreenControllerProvider =
    StateNotifierProvider<WishListScreenController, AsyncValue<void>>((ref) {
  return WishListScreenController(
    wishListService: ref.watch(wishListServiceProvider),
  );
});
