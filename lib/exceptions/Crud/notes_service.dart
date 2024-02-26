import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationCacheDirectory;
import 'package:path/path.dart' show join;

// Declaration of constants
const idColunm = "id";
const emailColunm = "email";
const userIdColunm = "user_id";
const textColunm = "text";
const isSyncedWithCloudColunm = "is_synced_with_cloud";
const dbName = 'notes.db';
const noteTable = 'Notes';
const userTable = 'User';
const createNoteTable = '''CREATE TABLE IF NOT EXIST  "Notes" (
	"Id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("Id"),
	FOREIGN KEY("user_id") REFERENCES "User"("Id")
); ''';
const createUserTable = ''' CREATE TABLE IF NOT EXIST "User" (
	"Id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("Id" AUTOINCREMENT)
);''';

// Exceptions
class DataBaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsException implements Exception {}

class DataBaseIsNotOpenException implements Exception {}

class CouldNotDeleteUserException implements Exception {}

class UserAlreadyExistExceptions implements Exception {}

class CouldNotDeleteNoteExceptions implements Exception {}

class CouldNotFindNoteException implements Exception {}

class CouldNotUpdateNoteException implements Exception {}

class NotesService {
  Database? _db;
  Future<DataBaseNote> updateNote(
      {required DataBaseNote note, required String text}) async {
    final db = _getDataBaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      textColunm: text,
      isSyncedWithCloudColunm: 0,
    });
    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DataBaseNote>> getAllNotes({required int id}) async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      noteTable,
    );
    return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));
  }

  Future<DataBaseNote> getNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return DataBaseNote.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteExceptions();
    }
  }

  Future<DataBaseNote> createNote({required DataBaseUser owner}) async {
    final db = _getDataBaseOrThrow();
    // Exist owner in databse with correct ID
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotDeleteUserException();
    }
    // Creation of the notes
    const text = '';
    final noteID = await db.insert(noteTable,
        {userIdColunm: owner.id, textColunm: text, isSyncedWithCloudColunm: 1});
    final note = DataBaseNote(
        id: noteID, userId: owner.id, text: text, isSyncedWithCloud: true);
    return note;
  }

  Future<DataBaseUser> getUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ? ',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotDeleteUserException();
    } else {
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<DataBaseUser> createUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ? ',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistExceptions();
    }
    final userID = await db.insert(userTable, {
      emailColunm: email.toLowerCase(),
    });
    return DataBaseUser(
      id: userID,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDataBaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationCacheDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // Execute Tables
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsException();
    }
  }
}

// Code Here !!!
@immutable
class DataBaseUser {
  final int id;
  final String email;
  const DataBaseUser({
    required this.id,
    required this.email,
  });
  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColunm] as int,
        email = map[emailColunm] as String;
  @override
  String toString() => 'Person , ID = $id , email = $email';
  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DataBaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColunm] as int,
        userId = map[userIdColunm] as int,
        text = map[textColunm] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColunm] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note , ID = $id , userId = $userId , isSyncedWithCloud = $isSyncedWithCloud';
  @override
  bool operator ==(covariant DataBaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
