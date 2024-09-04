import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/action_text_button.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/fake_auth_repository.dart';
import 'account_screen_controller.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      accountScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(
          context), //listen to error and show in a dialog boc in few lines of code
    );
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: state.isLoading
            ? const CircularProgressIndicator()
            : Text('Account'.hardcoded),
        actions: [
          ActionTextButton(
            text: 'Logout'.hardcoded,
            onPressed: state.isLoading
                ? null
                : () async {
                    final logout = await showAlertDialog(
                      context: context,
                      title: 'Are you sure?'.hardcoded,
                      cancelActionText: 'Cancel'.hardcoded,
                      defaultActionText: 'Logout'.hardcoded,
                    );
                    if (logout == true) {
                      /// separating between UI and business Logic this code await ref.read(authRepositoryProvider).signOut();
                      // Implemented only pop on success
                      /*
                With this code, the redirect logic will be called every time the authentication state changes, and will automatically take care of dismissing the sign-in and account pages after sign-in/sign-out.

This means that this code is no longer needed:

final success = await ref
                        .read(accountScreenControllerProvider.notifier)
                        .signOut();
// no longer needed
if (success) {
  Navigator.of(context).pop();
}
This is a great advantage as our application scales in complexity, because we now have a centralized place for redirecting routes in response to application state changes.          */
                      ref
                          .read(accountScreenControllerProvider.notifier)
                          .signOut();
                    }
                  },
          ),
        ],
      ),
      body: const ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: UserDataTable(),
      ),
    );
  }
}

/// Simple user data table showing the uid and email
class UserDataTable extends ConsumerWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme.titleSmall!;
    final user = ref.watch(authStateChangesProvider).value;
    return DataTable(
      columns: [
        DataColumn(
          label: Text(
            'Field'.hardcoded,
            style: style,
          ),
        ),
        DataColumn(
          label: Text(
            'Value'.hardcoded,
            style: style,
          ),
        ),
      ],
      rows: [
        _makeDataRow(
          'uid'.hardcoded,
          user?.uid ?? '',
          style,
        ),
        _makeDataRow(
          'email'.hardcoded,
          user?.email ?? '',
          style,
        ),
      ],
    );
  }

  DataRow _makeDataRow(String name, String value, TextStyle style) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            style: style,
          ),
        ),
        DataCell(
          Text(
            value,
            style: style,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
