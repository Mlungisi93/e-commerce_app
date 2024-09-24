// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartSyncService {
  CartSyncService(this.ref) {
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

//this condition willl be true if were previously not signed in  but now we are signed in
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  /// moves all items from the local to the remote cart taking into account the
  /// available quantities
  Future<void> _moveItemsToRemoteCart(String uid) async {
    // Get the local cart data
    final localCartRepository = ref.read(localCartRepositoryProvider);
    final localCart = await localCartRepository.fetchCart();
    if (localCart.items.isNotEmpty) {
      // Get the remote cart data
      final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
      final remoteCart = await remoteCartRepository.fetchCart(uid);
      final localItemsToAdd = await _getLocalItemsToAdd(localCart, remoteCart);
      // Add all the local items to the remote cart
      final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);
      // Write the updated remote cart data to the repository
      await remoteCartRepository.setCart(uid, updatedRemoteCart);
      // Remove all items from the local cart
      await localCartRepository.setCart(const Cart());
    }
  }

  Future<List<Item>> _getLocalItemsToAdd(
      Cart localCart, Cart remoteCart) async {
    // Get the list of products (needed to read the available quantities)
    final productsRepository = ref.read(productsRepositoryProvider);
    final products = await productsRepository.fetchProductsList();
    // Figure out which items need to be added
    final localItemsToAdd = <Item>[];
    for (final localItem in localCart.items.entries) {
      final productId = localItem.key;
      final localQuantity = localItem.value;
      // get the quantity for the corresponding item in the remote cart
      final remoteQuantity = remoteCart.items[productId] ?? 0;
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

final cartSyncServiceProvider = Provider<CartSyncService>((ref) {
  return CartSyncService(ref);
});
