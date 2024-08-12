import 'package:climbnotes/services/cloud/cloud_note.dart';

import 'package:climbnotes/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
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
          final note = notes.elementAt(index);
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
