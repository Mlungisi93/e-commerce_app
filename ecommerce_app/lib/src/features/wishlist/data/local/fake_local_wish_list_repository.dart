import 'package:ecommerce_app/src/features/wishlist/data/local/local_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeLocalWishListRepository implements LocalWishListRepository {
  FakeLocalWishListRepository({this.addDelay = true});
  final bool addDelay;

  final _wishList = InMemoryStore<WishList>(const WishList());

  @override
  Future<WishList> fetchWishList() async {
    return _wishList.value;
  }

  @override
  Stream<WishList> watchWishList() => _wishList.stream;

  @override
  Future<void> setWishList(WishList wishList) async {
    await delay(addDelay);
    _wishList.value = wishList;
  }
}
