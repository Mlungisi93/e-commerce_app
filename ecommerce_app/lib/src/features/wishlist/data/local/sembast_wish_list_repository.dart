import 'package:ecommerce_app/src/features/wishlist/data/local/local_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastWishListRepository implements LocalWishListRepository {
  SembastWishListRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastWishListRepository> makeDefault() async {
    return SembastWishListRepository(
        await createDatabase('default_wish_list.db'));
  }

  static const wishListItemsKey = 'wishListItems';

  @override
  Future<WishList> fetchWishList() async {
    final cartJson = await store.record(wishListItemsKey).get(db) as String?;
    if (cartJson != null) {
      return WishList.fromJson(cartJson);
    } else {
      return const WishList();
    }
  }

  @override
  Future<void> setWishList(WishList wishList) {
    return store.record(wishListItemsKey).put(db, wishList.toJson());
  }

  @override
  Stream<WishList> watchWishList() {
    final record = store.record(wishListItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return WishList.fromJson(snapshot.value as String);
      } else {
        return const WishList();
      }
    });
  }
}
