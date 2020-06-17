import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/models/ListThing.dart';

class ListsDatabase {

  static String createDatabaseSQL = "";   // concatenated series of queries to create Lists! database

  final Future<Database> _database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'lists_database.db'),
      onCreate: (db, version) => db.execute(createDatabaseSQL),
      version: 1,
    );
  });

  Future<void> insertItem(ListThing thing) async {
    // Get a reference to the database.
    final Database db = await _database;

    await db.insert(
      'lists',
      thing.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}