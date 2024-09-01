import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/app_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/action_text_button.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:go_router/go_router.dart';

/// Simple account screen showing some user info and a logout button.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //
        title: Text('Account'.hardcoded),
        actions: [
          ActionTextButton(
            text: 'Logout'.hardcoded,
            onPressed: () async {
              //showNotImplementedAlertDialog(context: context);
              // * Get the navigator beforehand to prevent this warning:
              // * Don't use 'BuildContext's across async gaps.
              // * More info here: https://youtu.be/bzWaMpD1LHY
              final goRouter = GoRouter.of(context);
              final logout = await showAlertDialog(
                context: context,
                title: 'Are you sure?'.hardcoded,
                cancelActionText: 'Cancel'.hardcoded,
                defaultActionText: 'Logout'.hardcoded,
              );
              if (logout == true) {
                // TODO: Sign out the user.
                goRouter.pop();
              }

              /// Generic function to show a platform-aware Material or Cupertino dialog
              // Future<bool?> showAlertDialog({
              //   required BuildContext context,
              //   required String title,
              //   String? content,
              //   String? cancelActionText,
              //   String defaultActionText = 'OK',
              // }) async {
              //   return showDialog(
              //     context: context,
              //     // * Only make the dialog dismissible if there is a cancel button
              //     barrierDismissible: cancelActionText != null,
              //     // * AlertDialog.adaptive was added in Flutter 3.13
              //     builder: (context) => AlertDialog.adaptive(
              //       title: Text(title),
              //       content: content != null ? Text(content) : null,
              //       // * Use [TextButton] or [CupertinoDialogAction] depending on the platform
              //       actions: kIsWeb || !Platform.isIOS
              //           ? <Widget>[
              //         if (cancelActionText != null)
              //           TextButton(
              //             child: Text(cancelActionText),
              //             onPressed: () => context.pop(false),
              //           ),
              //         TextButton(
              //           child: Text(defaultActionText),
              //           onPressed: () => context.pop(true),
              //         ),
              //       ]
              //           : <Widget>[
              //         if (cancelActionText != null)
              //           CupertinoDialogAction(
              //             child: Text(cancelActionText),
              //             onPressed: () => context.pop(false),
              //           ),
              //         CupertinoDialogAction(
              //           child: Text(defaultActionText),
              //           onPressed: () => context.pop(true),
              //         ),
              //       ],
              //     ),
              //   );
              // }
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
class UserDataTable extends StatelessWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleSmall!;
    // TODO: get user from auth repository
    const user = AppUser(uid: '123', email: 'test@test.com');
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
          user.uid,
          style,
        ),
        _makeDataRow(
          'email'.hardcoded,
          user.email ?? '',
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
