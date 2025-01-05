// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wish_list_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wish_list.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishListSyncService {
  WishListSyncService(this.ref) {
    _init();
  }
  //to read other providers
  final Ref ref;

//used to setup our listener
  void _init() {
    //we need to add a type annotation
    // since the provider we are listening to is a stream provider then we should use <AsyncValue<Appuser?>> as when we watch authStateChangesProvider we always get this type
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (previous, next) {
      //we want to check if the listener was called because we are just signed in by checking this previous and next arguments
      //was user previously signed in?
      final previousUser = previous?.value;
      final user = next.value;

//this condition will be true if were previously not signed in  but now we are signed in
      if (previousUser == null && user != null) {
        _moveItemsToRemoteWishList(user.uid);
      }
    });
  }

  /// moves all items from the local to the remote cart taking into account the
  /// available quantities
  Future<void> _moveItemsToRemoteWishList(String uid) async {
    try {
      //paste
      // Get the local cart data
      final localWishListRepository = ref.read(localWishListRepositoryProvider);
      final localWishList = await localWishListRepository.fetchWishList();
      if (localWishList.items.isNotEmpty) {
        // Get the remote cart data
        final remoteWishListRepository =
            ref.read(remoteWishListRepositoryProvider);
        final remoteWishList =
            await remoteWishListRepository.fetchWishList(uid);
        final localItemsToAdd =
            await _getLocalItemsToAdd(localWishList, remoteWishList);
        // Add all the local items to the remote cart
        final updatedRemoteWishList = remoteWishList.addItems(localItemsToAdd);
        // Write the updated remote cart data to the repository
        await remoteWishListRepository.setWishList(uid, updatedRemoteWishList);
        // Remove all items from the local cart
        await localWishListRepository.setWishList(const WishList());
      }
    } catch (e) {
      // TODO: handle the error
    }
  }

  Future<List<Item>> _getLocalItemsToAdd(
      WishList localWishList, WishList remoteWishList) async {
    // Get the list of products (needed to read the available quantities)
    final productsRepository = ref.read(productsRepositoryProvider);
    final products = await productsRepository.fetchProductsList();
    // Figure out which items need to be added
    final localItemsToAdd = <Item>[];
    for (final localItem in localWishList.items.entries) {
      final productId = localItem.key;
      final localQuantity = localItem.value;
      // get the quantity for the corresponding item in the remote cart
      final remoteQuantity = remoteWishList.items[productId] ?? 0;
      final product = products.firstWhere((product) => product.id == productId);
      // Cap the quantity of each item to the available quantity
      final cappedLocalQuantity = min(
        localQuantity,
        product.availableQuantity - remoteQuantity,
      );
      // if the capped quantity is > 0, add to the list of items to add
      if (cappedLocalQuantity > 0) {
        localItemsToAdd
            .add(Item(productId: productId, quantity: cappedLocalQuantity));
      }
    }
    return localItemsToAdd;
  }
}

final wishListSyncServiceProvider = Provider<WishListSyncService>((ref) {
  return WishListSyncService(ref);
});
