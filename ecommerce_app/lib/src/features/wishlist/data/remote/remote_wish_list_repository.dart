import 'package:ecommerce_app/src/features/wishlist/data/remote/fake_remote_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing cart data for a specific user ID
abstract class RemoteWishListRepository {
  Future<WishList> fetchWishList(String uid);

  Stream<WishList> watchWishList(String uid);

  Future<void> setWishList(String uid, WishList wishList);
}

final remoteWishListRepositoryProvider =
    Provider<RemoteWishListRepository>((ref) {
  // TODO: replace with "real" remote cart repository
  return FakeRemoteWishListRepository();
});
