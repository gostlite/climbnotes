import 'package:climbnotes/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: "sharing",
      content: "You cannot share an empty note",
      optionBuilder: () {
        return {'ok': null};
      });
}
