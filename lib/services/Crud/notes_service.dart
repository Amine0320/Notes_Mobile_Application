// import 'dart:async';
// import 'package:flutter/widgets.dart';
// import 'package:notes_app/services/Crud/crud_exceptions.dart';
// import 'package:notes_app/extensions/list/filter.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart'
//     show MissingPlatformDirectoryException, getApplicationCacheDirectory;
// import 'package:path/path.dart' show join;

// // Declaration of constants
// const idColunm = "id";
// const emailColunm = "email";
// const userIdColunm = "user_id";
// const textColunm = "text";
// const isSyncedWithCloudColunm = "is_synced_with_cloud";
// const dbName = 'notes.db';
// const noteTable = 'Notes';
// const userTable = 'User';
// const createNoteTable = '''CREATE TABLE IF NOT EXIST  "Notes" (
// 	"Id"	INTEGER NOT NULL,
// 	"user_id"	INTEGER NOT NULL,
// 	"text"	TEXT,
// 	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// 	PRIMARY KEY("Id"),
// 	FOREIGN KEY("user_id") REFERENCES "User"("Id")
// ); ''';
// const createUserTable = ''' CREATE TABLE IF NOT EXIST "User" (
// 	"Id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("Id" AUTOINCREMENT)
// );''';

// class NotesService {
//   Database? _db;
//   List<DataBaseNote> _notes = [];
//   DataBaseUser? _user;
//   // Make a singleton pattern to make notes unique ! NotesService
//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DataBaseNote>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;
//   late final StreamController<List<DataBaseNote>> _notesStreamController;
//   Stream<List<DataBaseNote>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == currentUser.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });

//   Future<DataBaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUserException {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     _notes = allNotes.toList();
//     _notesStreamController.add(_notes);
//   }

//   Future<DataBaseNote> updateNote(
//       {required DataBaseNote note, required String text}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     //make sure the note exists
//     await getNote(id: note.id);
//     // Update the DataBase
//     final updatesCount = await db.update(
//       noteTable,
//       {
//         textColunm: text,
//         isSyncedWithCloudColunm: 0,
//       },
//       where: 'id = ?',
//       whereArgs: [note.id],
//     );
//     if (updatesCount == 0) {
//       throw CouldNotUpdateNoteException();
//     } else {
//       final updateNote = await getNote(id: note.id);
//       _notes.removeWhere((note) => note.id == updateNote.id);
//       _notes.add(updateNote);
//       _notesStreamController.add(_notes);
//       return updateNote;
//     }
//   }

//   Future<Iterable<DataBaseNote>> getAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//     );
//     return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));
//   }

//   Future<DataBaseNote> getNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id=?',
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNoteException();
//     } else {
//       final note = DataBaseNote.fromRow(notes.first);
//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);
//       return note;
//     }
//   }

//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final numberOfDeletions = await db.delete(noteTable);
//     _notes = [];
//     _notesStreamController.add(_notes);
//     return numberOfDeletions;
//   }

//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final deletedCount = await db.delete(
//       noteTable,
//       where: 'id=?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteNoteExceptions();
//     } else {
//       // final countBefore = _notes.length;
//       _notes.removeWhere((note) => note.id == id);
//       _notesStreamController.add(_notes);
//     }
//   }

//   Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     // Exist owner in databse with correct ID
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotDeleteUserException();
//     }
//     // Creation of the notes
//     const text = '';
//     final noteID = await db.insert(noteTable,
//         {userIdColunm: owner.id, textColunm: text, isSyncedWithCloudColunm: 1});
//     final note = DataBaseNote(
//         id: noteID, userId: owner.id, text: text, isSyncedWithCloud: true);

//     _notes.add(note);
//     _notesStreamController.add(_notes);
//     return note;
//   }

//   Future<DataBaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ? ',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isEmpty) {
//       throw CouldNotFindUserException();
//     } else {
//       return DataBaseUser.fromRow(results.first);
//     }
//   }

//   Future<DataBaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ? ',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExistExceptions();
//     }
//     final userID = await db.insert(userTable, {
//       emailColunm: email.toLowerCase(),
//     });
//     return DataBaseUser(
//       id: userID,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDataBaseOrThrow();
//     final deletedCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deletedCount != 1) {
//       throw CouldNotDeleteUserException();
//     }
//   }

//   Database _getDataBaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DataBaseIsNotOpenException();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DataBaseIsNotOpenException();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DataBaseAlreadyOpenException {}
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DataBaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationCacheDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       // Execute Tables
//       await db.execute(createUserTable);
//       await db.execute(createNoteTable);
//       // read all notes and place them in _cacheNotes!
//       await _cacheNotes();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsException();
//     }
//   }
// }

// // Code Here !!!
// @immutable
// class DataBaseUser {
//   final int id;
//   final String email;
//   const DataBaseUser({
//     required this.id,
//     required this.email,
//   });
//   DataBaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColunm] as int,
//         email = map[emailColunm] as String;
//   @override
//   String toString() => 'Person , ID = $id , email = $email';
//   @override
//   bool operator ==(covariant DataBaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// class DataBaseNote {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSyncedWithCloud;

//   DataBaseNote({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSyncedWithCloud,
//   });
//   DataBaseNote.fromRow(Map<String, Object?> map)
//       : id = map[idColunm] as int,
//         userId = map[userIdColunm] as int,
//         text = map[textColunm] as String,
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColunm] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'Note , ID = $id , userId = $userId , isSyncedWithCloud = $isSyncedWithCloud';
//   @override
//   bool operator ==(covariant DataBaseNote other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
