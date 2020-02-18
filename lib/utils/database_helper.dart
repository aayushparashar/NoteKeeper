import 'dart:async';

import 'package:note_keeper/models/note.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databasehelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'Id';
  String colTitle = 'Title';
  String colDescription = 'Description';
  String colDate = 'Date';
  String colPriority = 'Priority';

  DatabaseHelper.createInstance();

  factory DatabaseHelper() {
    if (_databasehelper == null) {
      _databasehelper = DatabaseHelper.createInstance();
    }
    return _databasehelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await intializeDatabse();
    }
    return _database;
  }

  Future<Database> intializeDatabse() async {
    var directory = await getDatabasesPath();
    String path = p.join(directory, 'notes.db');

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createdb);
    return notesDatabase;
  }

  void _createdb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId Integer Primary key autoincrement, $colTitle TEXT, $colDescription TEXT, $colPriority Integer, $colDate TEXT)');
  }

//Fetch
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

//Insert
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = db.insert(noteTable, note.toMap());
    return result;
  }

//Update
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = db.update(noteTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

//Delete
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = db.delete(noteTable, where: '$colId = $id');
    return result;
  }

//GetNumberofInstances
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var notelist = await getNoteMapList();
    int count = notelist.length;
    List<Note> x = new List<Note>();
    for (int i = 0; i < count; i++) {
      x.add(Note.fromMapObject(notelist[i]));
    }
    return x;
  }
}
