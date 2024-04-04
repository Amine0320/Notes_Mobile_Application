import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note !',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
