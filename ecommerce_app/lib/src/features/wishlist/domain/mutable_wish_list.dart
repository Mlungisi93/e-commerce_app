import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';

/// Helper extension used to mutate the items in the shopping cart.
extension MutableCart on WishList {
  /// add an item to the cart by *overriding* the quantity if it already exists
  WishList setItem(Item item) {
    final copy = Map<ProductID, int>.from(items);
    copy[item.productId] = item.quantity;
    return WishList(copy);
  }

  /// add an item to the cart by *updating* the quantity if it already exists
  WishList addItem(Item item) {
    final copy = Map<ProductID, int>.from(items);
    // * update item quantity. Read this for more details:
    // * https://codewithandrea.com/tips/dart-map-update-method/
    copy.update(
      item.productId,
      // if there is already a value, update it by adding the item quantity
      (value) => item.quantity + value,
      // otherwise, add the item with the given quantity
      ifAbsent: () => item.quantity,
    );
    return WishList(copy);
  }

  /// add a list of items to the cart by *updating* the quantities of items that
  /// already exist
  WishList addItems(List<Item> itemsToAdd) {
    final copy = Map<ProductID, int>.from(items);
    for (var item in itemsToAdd) {
      copy.update(
        item.productId,
        // if there is already a value, update it by adding the item quantity
        (value) => item.quantity + value,
        // otherwise, add the item with the given quantity
        ifAbsent: () => item.quantity,
      );
    }
    return WishList(copy);
  }

  /// if an item with the given productId is found, remove it
  WishList removeItemById(ProductID productId) {
    final copy = Map<ProductID, int>.from(items);
    copy.remove(productId);
    return WishList(copy);
  }
}

// import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
// import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';
// import 'package:flutter/foundation.dart';
// import 'package:ecommerce_app/src/features/products/domain/product.dart';

// /// A mutable version of the WishList class that allows adding and removing items.
// extension MutableWishList on WishList {
//   WishList addItem(Item item) {
//     items.add(item.productId);
//     return WishList(items);
//   }

//   WishList removeItemById(ProductID productId) {
//     items.remove(productId);
//     return WishList(items);
//   }
// }
