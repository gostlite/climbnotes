import 'package:flutter/material.dart';

ScaffoldFeatureController<Widget, SnackBarClosedReason> showSnackBar(
    BuildContext context, String content) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(content)));
}

Future<void> showTextDialog(
        {required BuildContext context,
        required String mytitle,
        required String content,
        required Function proceed}) =>
    showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(mytitle),
              content: Text(content),
              actions: [
                TextButton(
                    onPressed: () => proceed, child: const Text("Proceed")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"))
              ],
            ));
