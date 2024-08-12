import 'package:climbnotes/services/crud/crudnote_service.dart';
import 'package:climbnotes/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onNoteDelete;
  final NoteCallback onTap;
  const NoteListView(
      {super.key,
      required this.notes,
      required this.onNoteDelete,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            onTap: () => {
              onTap(note),
            },
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
                  onNoteDelete(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
          );
        });
  }
}
