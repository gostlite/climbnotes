import "package:climbnotes/services/crud/crud_exceptions.dart";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";
import "package:path/path.dart" as pathJoin show join;

class NoteService {
  Database? _db;
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDbOrThrow();
    final notes = await db.query(noteTable);
    if (notes.isEmpty) {
      throw NoteNotFoundException();
    }
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDbOrThrow();
    // await getNote(noteId: note.id);
    final updatedNote = await db.update(noteTable, {
      noteColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updatedNote == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      return await getNote(noteId: note.id);
    }
  }

  Future<DatabaseNote> getNote({required int noteId}) async {
    final db = _getDbOrThrow();
    final note = await db
        .query(noteTable, limit: 1, where: "id = ?", whereArgs: [noteId]);
    if (note.isEmpty) {
      throw NoteNotFoundException();
    } else {
      return DatabaseNote.fromRow(note.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDbOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDbOrThrow();

    final deletedNote =
        await db.delete(noteTable, where: "id = ?", whereArgs: [id]);
    if (deletedNote == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> createNote(
      {required DatabaseUser owner, required note}) async {
    final db = _getDbOrThrow();

    // make sure user exists with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    } else {
      final noteId = await db.insert(noteTable, {
        userIdColumn: owner.id,
        noteColumn: note,
        isSyncedWithCloudColumn: 1
      });
      return DatabaseNote(
        id: noteId,
        isSyncedWithCloud: true,
        note: note,
        userId: owner.id,
      );
    }
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDbOrThrow();
    final user = await db.query(userTable,
        limit: 1, where: "email = ?", whereArgs: [email.toLowerCase()]);
    if (user.isEmpty) {
      return DatabaseUser.fromRow(user.first);
    } else {
      throw CouldNotFindUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDbOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: "email=?", whereArgs: [email.toLowerCase()]);
    if (result.isNotEmpty) {
      throw UserAlreadyExistsException();
    } else {
      final newUserId =
          await db.insert(userTable, {userEmailColumn: email.toLowerCase()});
      return DatabaseUser(id: newUserId, email: email.toLowerCase());
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDbOrThrow();
    final deletedCount = await db
        .delete(userTable, where: "email=?", whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDbOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) throw DataBaseAlreadyOpenException();
    try {
      final docPath = await getApplicationDocumentsDirectory();
      final dbPath = pathJoin.join(docPath.path, dbName); // joining the paths
      final db = await openDatabase(dbPath);
      _db = db;

// creating the user table

      await db.execute(createUserTable);

      // create note table

      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectoryException();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[userIdColumn] as int,
        email = map[userEmailColumn] as String;

  @override
  String toString() => "Person, id=$id and email= $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String note;
  final bool isSyncedWithCloud;
  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.note,
    required this.isSyncedWithCloud,
  });
  DatabaseNote.fromRow(Map<String, Object?> map)
      : userId = map[userIdColumn] as int,
        note = map[noteColumn] as String,
        id = map[noteIdColumn] as int,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      "Note, id = $id userId = $userId, isSyncedWithCloud = $isSyncedWithCloud text = $note";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const userIdColumn = "id";
const userEmailColumn = "email";
const noteIdColumn = "id";
const noteColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createNoteTable = """
          CREATE TABLE IF NOT EXISTS "note" (
            "id"	INTEGER NOT NULL,
            "user_id"	INTEGER NOT NULL,
            "text"	TEXT,
            "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
            PRIMARY KEY("id" AUTOINCREMENT),
            FOREIGN KEY("id") REFERENCES "",
            FOREIGN KEY("user_id") REFERENCES "user"("id")
          );
""";
const createUserTable = """
          CREATE TABLE IF NOT EXISTS "user" (
            "id"	INTEGER NOT NULL,
            "email"	TEXT NOT NULL UNIQUE,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
""";
