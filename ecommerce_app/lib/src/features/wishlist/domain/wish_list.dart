import 'dart:convert';
import 'package:ecommerce_app/src/features/wishlist/domain/item.dart';
import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

/// Model class representing the wishlist contents.
class WishList {
  const WishList([this.items = const {}]);

  /// All the items in the wishlist, where:
  /// - key: product ID
  /// - value: product ID
  final Map<ProductID, int> items;

  Map<String, dynamic> toMap() {
    return {
      'items': items,
    };
  }

  factory WishList.fromMap(Map<String, dynamic> map) {
    return WishList(
      Map<ProductID, int>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory WishList.fromJson(String source) =>
      WishList.fromMap(json.decode(source));

  @override
  String toString() => 'WishList(items: $items)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WishList && mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension WishListItems on WishList {
  List<Item> toItemsList() {
    return items.entries.map((entry) {
      return Item(
        productId: entry.key,
        quantity: entry.value,
      );
    }).toList();
  }
}

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:ecommerce_app/src/features/products/domain/product.dart';

// /// Model class representing the wishlist contents.
// class WishList {
//   const WishList([this.items = const []]);

//   /// All the items in the wishlist, stored as a list of product IDs.
//   final List<ProductID> items;

//   Map<String, dynamic> toMap() {
//     return {
//       'items': items,
//     };
//   }

//   factory WishList.fromMap(Map<String, dynamic> map) {
//     return WishList(
//       List<ProductID>.from(map['items']),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory WishList.fromJson(String source) =>
//       WishList.fromMap(json.decode(source));

//   @override
//   String toString() => 'WishList(items: $items)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is WishList && listEquals(other.items, items);
//   }

//   @override
//   int get hashCode => items.hashCode;
// }

// extension WishListItems on WishList {
//   List<ProductID> toItemsList() {
//     return items;
//   }
// }
/*
extension WishListItems on WishList {
  List<Item> toItemsList() {
   return items.map((entry) {
      return Item(
        productId: entry,
      );
    }).toList();
  }
  }
*/
