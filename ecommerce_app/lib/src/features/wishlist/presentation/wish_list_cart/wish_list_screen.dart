import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';

import 'package:ecommerce_app/src/features/wishlist/application/wish_list_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wish_list.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wish_list_cart/wish_list_item.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wish_list_cart/wish_list_items_builder.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wish_list_cart/wish_list_screen_controller.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shopping cart screen showing the items in the cart (with editable
/// quantities) and a button to checkout.
class WishListCartScreen extends ConsumerWidget {
  const WishListCartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      wishListScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(wishListScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Wish List'.hardcoded),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final wishListValue = ref.watch(wishListProvider);
          return AsyncValueWidget<WishList>(
            value: wishListValue,
            data: (wishList) => WishListItemsBuilder(
              items: wishList.toItemsList(),
              itemBuilder: (_, item, index) => WishListCartItem(
                item: item,
                itemIndex: index,
              ),
              ctaBuilder: (_) => PrimaryButton(
                text: 'Add To Cart'.hardcoded,
                isLoading: state.isLoading,
                onPressed: () => () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
