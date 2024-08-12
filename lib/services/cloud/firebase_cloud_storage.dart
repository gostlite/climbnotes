import 'package:climbnotes/services/cloud/cloud_note.dart';
import 'package:climbnotes/services/cloud/cloud_storage_constant.dart';
import 'package:climbnotes/services/cloud/cloud_storage_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseCloudStorage {
  final _notes = FirebaseFirestore.instance.collection("notes");

  Stream<Iterable<CloudNote>> allNotes({required String ownerId}) {
    return _notes
        .where(ownerUserIdFieldName, isEqualTo: ownerId)
        .snapshots()
        .map((events) => events.docs.map((doc) => CloudNote.fromSnapshot(doc)));
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await _notes.doc(documentId).delete();
    } catch (e) {
      CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await _notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<Iterable<CloudNote>> getAllNotes({required String ownerId}) async {
    try {
      return await _notes
          .where(ownerUserIdFieldName, isEqualTo: ownerId)
          .get()
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                    documentId: doc.id,
                    ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                    text: doc.data()[textFieldName] as String);
              }));
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  //initializing the singleton
  static final FireBaseCloudStorage _shared =
      FireBaseCloudStorage._sharedInstance();
  FireBaseCloudStorage._sharedInstance();
  factory FireBaseCloudStorage() => _shared;

  void createNewNote({required String ownerUserId}) async {
    _notes.add({ownerUserIdFieldName: ownerUserId, textFieldName: ""});
  }
}
