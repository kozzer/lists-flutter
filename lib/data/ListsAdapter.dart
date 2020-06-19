import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/models/ListThing.dart';

class ListsDatabase {

  static final Future<Database> _database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'lists_database.db'),
      onCreate: _onCreate,
      version: 1,
    );
  });

  static Future<List<ListThing>> getAllListsData() async {
    final Database db = await _database;
    List<ListThing> listsData = [];
    var rawMapData = await db.query('lists', columns: ['thingID', 'parentThingID', 'label', 'isList', 'icon', 'isMarked', 'sortOrder']);
 
    // TODO need to convert rawMapData to list of ListThing objects
    //rawMapData.forEach((element) { print(element); });

    print('getting lists data');
    return listsData;
  }

  static Future<int> insertThing(ListThing thing) async {
    final Database db = await _database;
    return await db.insert(                           // db.insert() returns ID of new record
      'lists',
      thing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,      // fail will cause error if attempting to insert dup IDs
    );
  }

  static Future<void> removeThing(int thingID) async {
    final Database db = await _database;
    await db.execute('DELETE FROM lists WHERE thingID = $thingID');
  }

  static Future<void> updateThing(ListThing thing) async {
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
  static String createDatabaseSQL = '''
    CREATE TABLE lists (
      thingID         INTEGER   NOT NULL PRIMARY KEY,
      parentThingID   INTEGER   NOT NULL,
      label           TEXT      NOT NULL,
      isList          INTEGER   NOT NULL,
      icon            TEXT,
      isMarked        INTEGER   NOT NULL,
      sortOrder       INTEGER   NOT NULL,
    );
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder) 
               VALUES (0, 0, 'Main List', 1, NULL, 0, 0);
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
               VALUES (1, 0, 'First List Item', 0, NULL, 0, 0);''';

}