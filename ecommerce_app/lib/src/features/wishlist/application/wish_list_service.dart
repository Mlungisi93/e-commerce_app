import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';

import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wish_list.dart';

import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListService {
  WishListService(this.ref);
  final Ref ref;

  /// fetch the wish List from the local or remote repository
  /// depending on the user auth state
  Future<WishList> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteWishListRepositoryProvider).fetchWishList(user.uid);
    } else {
      return ref.read(localWishListRepositoryProvider).fetchWishList();
    }
  }

  /// save the wish List to the local or remote repository
  /// depending on the user auth state
  Future<void> _setWishList(WishList wishList) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteWishListRepositoryProvider)
          .setWishList(user.uid, wishList);
    } else {
      await ref.read(localWishListRepositoryProvider).setWishList(wishList);
    }
  }

  /// sets an item in the local or remote wish List depending on the user auth state
  Future<void> setItem(Item item) async {
    final wishList = await _fetchCart();
    //final updated = wishList.setItem(item);
    final updated = wishList.addItem(item);
    await _setWishList(updated);
  }

  /// adds an item in the local or remote wishList depending on the user auth state
  Future<void> addItem(Item item) async {
    final wishList = await _fetchCart();
    final updated = wishList.addItem(item);
    await _setWishList(updated);
  }

  /// removes an item from the local or remote wishList depending on the user auth
  /// state
  Future<void> removeItemById(ProductID productId) async {
    final wishList = await _fetchCart();
    final updated = wishList.removeItemById(productId);
    await _setWishList(updated);
  }
}

final wishListServiceProvider = Provider<WishListService>((ref) {
  return WishListService(ref);
});

final wishListProvider = StreamProvider<WishList>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(remoteWishListRepositoryProvider).watchWishList(user.uid);
  } else {
    return ref.watch(localWishListRepositoryProvider).watchWishList();
  }
});

final wishListItemsCountProvider = Provider<int>((ref) {
  return ref.watch(wishListProvider).maybeMap(
        data: (wishList) => wishList.value.items.length,
        orElse: () => 0,
      );
});

final WishListTotalProvider = Provider.autoDispose<double>((ref) {
  final wishList = ref.watch(wishListProvider).value ?? const WishList();
  final productsList = ref.watch(productsListStreamProvider).value ?? [];
  if (wishList.items.isNotEmpty && productsList.isNotEmpty) {
    var total = 0.0;
    for (final item in wishList.items.entries) {
      final product =
          productsList.firstWhere((product) => product.id == item.key);
      total += product.price * item.value;
    }
    return total;
  } else {
    return 0.0;
  }
});

final itemAvailableQuantityProvider =
    Provider.autoDispose.family<int, Product>((ref, product) {
  final wishList = ref.watch(wishListProvider).value;
  if (wishList != null) {
    // get the current quantity for the given product in the wish List
    final quantity = wishList.items[product.id] ?? 0;
    // subtract it from the product available quantity
    return max(0, product.availableQuantity - quantity);
  } else {
    return product.availableQuantity;
  }
});
