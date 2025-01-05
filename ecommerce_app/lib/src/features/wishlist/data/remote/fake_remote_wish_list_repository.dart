import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wish_list_repository.dart';

import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';

import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeRemoteWishListRepository implements RemoteWishListRepository {
  FakeRemoteWishListRepository({this.addDelay = true});
  final bool addDelay;

  /// An InMemoryStore containing the shopping cart data for all users, where:
  /// key: uid of the user
  /// value: Cart of that user
  final _wishLists = InMemoryStore<Map<String, WishList>>({});

  @override
  Future<WishList> fetchWishList(String uid) {
    return Future.value(_wishLists.value[uid] ?? const WishList());
  }

  @override
  Stream<WishList> watchWishList(String uid) {
    return _wishLists.stream
        .map((wishListData) => wishListData[uid] ?? const WishList());
  }

  @override
  Future<void> setWishList(String uid, WishList wishlist) async {
    await delay(addDelay);
    // First, get the current wishlist data for all users
    final wishLists = _wishLists.value;
    // Then, set the wishlist for the given uid
    wishLists[uid] = wishlist;
    // Finally, update the carts data (will emit a new value)
    _wishLists.value = wishLists;
  }
}
