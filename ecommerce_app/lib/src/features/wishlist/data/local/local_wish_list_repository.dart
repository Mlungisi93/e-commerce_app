import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing local cart data (guest user)
abstract class LocalWishListRepository {
  Future<WishList> fetchWishList();

  Stream<WishList> watchWishList();

  Future<void> setWishList(WishList wishList);
}

final localWishListRepositoryProvider =
    Provider<LocalWishListRepository>((ref) {
  // * Override this in the main method
  throw UnimplementedError();
});
