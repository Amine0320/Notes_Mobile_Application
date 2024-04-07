import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Password reset",
    content: "We have send you a reset link . Please check you email ",
    optionsBuilder: () => {
      "ok": null,
    },
  );
}
