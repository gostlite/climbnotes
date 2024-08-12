import 'package:climbnotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog<bool>(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete Note",
    content: "Are you sure you want to delete note",
    optionBuilder: () => {"Yes": true, "No": false},
  ).then((value) => value ?? false);
}
