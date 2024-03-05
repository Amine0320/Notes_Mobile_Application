import 'package:flutter/material.dart';
import 'package:notes_app/exceptions/Crud/notes_service.dart';
import 'package:notes_app/utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteClaaBack = void Function(DataBaseNote);

class NotesListView extends StatelessWidget {
  final List<DataBaseNote> notes;
  final DeleteNoteClaaBack onDeleteNote;
  const NotesListView(
      {super.key, required this.notes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
