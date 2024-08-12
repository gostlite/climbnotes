import 'package:climbnotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogoutDialog<bool>(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Logout",
    content: "Are you sure you want to logout",
    optionBuilder: () => {
      "Cancel": false,
      "Confirm": true,
    },
  ).then((value) => value ?? false);
}
