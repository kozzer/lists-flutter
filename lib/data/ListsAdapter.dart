import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/models/ListThing.dart';


final Future<Database> _database = getDatabasesPath().then((String path) async {


  print('KOZZER - deleting existing database');
  var fse = File(join(path, 'lists_database.db'));
  if (await fse.exists()){
    fse.delete();
  }

  return openDatabase(
    join(path, 'lists_database.db'),
    onCreate: _onCreate,
    version: 1,
  );
});

Future<List<ListThing>> getAllListsData() async {

  print('KOZZER - getting lists data');

  final Database  db = await _database;
  final List<ListThing> listsData = <ListThing>[];
  final List<Map<String, dynamic>> rawMapData = await db.query('lists', columns: <String>['thingID', 'parentThingID', 'label', 'isList', 'icon', 'isMarked', 'sortOrder']);

  print('KOZZER - records read: ${rawMapData.length}');

  for (final Map<String, dynamic> map in rawMapData){

    print('KOZZER - map: $map');

    listsData.add(ListThing(
      thingID:        map['thingID']        as int,
      parentThingID:  map['parentThingID']  as int,
      label:          map['label']          as String,
      isList:         map['isList']         as bool,
      icon:           map['icon']           as IconData,
      isMarked:       map['isMarked']       as bool,
      sortOrder:      map['sortOrder']      as int    
    ));
  }

  print('KOZZER - listsData size: ${listsData.length}');

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
Future<void> _onCreate(Database db, int version) async {
  print('KOZZER - in _onCreate, executing create script');
  db.execute(createDatabaseSQL);
  print('KOZZER - in _onCreate, executing create script');
  db.execute(insertMainList);  
  print('KOZZER - in _onCreate, executing create script');
  db.execute(insertFirstItem);  
  print('KOZZER - in _onCreate, executing create script');
  db.execute(insertSecondList);
}

// SQL Queries
const String createDatabaseSQL = '''
  CREATE TABLE lists (
    thingID         INTEGER   NOT NULL PRIMARY KEY,
    parentThingID   INTEGER   NOT NULL,
    label           TEXT      NOT NULL,
    isList          INTEGER   NOT NULL,
    icon            TEXT,
    isMarked        INTEGER   NOT NULL,
    sortOrder       INTEGER   NOT NULL
  );''';
  const String insertMainList = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder) 
      VALUES (0, -1, '[Main List]', 1, NULL, 0, 0);''';
  const String insertFirstList = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
      VALUES (1, 0, 'First List', 1, NULL, 0, 0);''';
  const String insertFirstItem = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
      VALUES (2, 1, 'First List Item', 0, NULL, 0, 0);'''; 
  const String insertSecondList = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
      VALUES (3, 0, 'Second List', 0, NULL, 0, 1);''';           

