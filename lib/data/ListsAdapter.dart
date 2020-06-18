import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/models/ListThing.dart';

class ListsDatabase {

  final Future<Database> _database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'lists_database.db'),
      onCreate: _onCreate,
      version: 1,
    );
  });

  Future<List<ListThing>> getAllListsData() async {
    final Database db = await _database;
    List<ListThing> listsData = [];
    var rawMapData = await db.query('lists', columns: ['thingID', 'parentListID', 'label', 'isList', 'icon', 'isMarked', 'sortOrder']);
 
    // need to convert rawMapData to list of ListThing objects

    return listsData;
  }

  Future<int> insertThing(ListThing thing) async {
    final Database db = await _database;
    return await db.insert(                           // db.insert() returns ID of new record
      'lists',
      thing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,      // fail will cause error if attempting to insert dup IDs
    );
  }

  Future<void> removeThing(int thingID) async {
    final Database db = await _database;
    await db.execute('DELETE FROM lists WHERE thingID = $thingID');
  }

  Future<void> updateThing(ListThing thing) async {
    final Database db = await _database;
    await db.insert(
      'lists',
      thing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,   // Replace will update record with new version
    );
  }

  // Executes only once - to create the database
  static _onCreate(Database db, int version) async {
    db.execute(createDatabaseSQL);
  }

  // SQL Queries
  static String createDatabaseSQL = "";   // concatenated series of queries to create Lists! database

}