import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/models/ListThing.dart';

class ListsDataAdapter {
  static final ListsDataAdapter _instance = new ListsDataAdapter.internal();
  factory ListsDataAdapter() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  ListsDataAdapter.internal();

  initDb() async {

    var path = await getDatabasesPath();

    print('KOZZER - deleting existing database');
    var dbf = File(join(path, 'lists_database.db'));
    if (await dbf.exists()){
      dbf.delete();
    }

    print('KOZZER - opening database');
    return openDatabase(
      join(path, 'lists_database.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  void _onCreate(Database db, int version) async {
    print('KOZZER - in _onCreate, executing create script');
    await db.execute(createDatabaseSQL);
    print('KOZZER - in _onCreate, executing create script');
    await db.execute(insertMainList);  
    print('KOZZER - in _onCreate, executing create script');
    await db.execute(insertFirstItem);  
    print('KOZZER - in _onCreate, executing create script');
    await db.execute(insertSecondList);
  }

  Future<int> saveData(ListThing thing) async {
    var dbClient = await db;
    int res = await dbClient.insert("lists", thing.toMap());
    return res;
  }

  Future<List<ListThing>> getUserModelData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM lists";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return null;

    List<ListThing> list = result.map((item) {
      return ListThing.fromMap(item);
    }).toList();

    print('KOZZER -- $result');
    return list;
  }

  Future<List<ListThing>> getChildItemsForListId(int listID) async {
    var dbClient = await db;
    String sql = "SELECT * FROM lists WHERE parentThingID = $listID";

    var result = await dbClient.rawQuery(sql);
    if (result.length == 0) return List<ListThing>();

    List<ListThing> list = result.map((item) {
      return ListThing.fromMap(item);
    }).toList();

    // Nested loop using recursion to populate data model
    for(ListThing thing in list){
      List<ListThing> childThings = await getChildItemsForListId(thing.thingID);
      for(ListThing child in childThings){
        thing.addChildThing(child);
      }
    }

    print('KOZZER -- listID result: $result');
    return list;
  }


  // SQL Queries
static final String createDatabaseSQL = '''
  CREATE TABLE lists (
    thingID         INTEGER   NOT NULL PRIMARY KEY,
    parentThingID   INTEGER   NOT NULL,
    label           TEXT      NOT NULL,
    isList          INTEGER   NOT NULL,
    icon            TEXT,
    isMarked        INTEGER   NOT NULL,
    sortOrder       INTEGER   NOT NULL
  );''';

  static final  String insertMainList = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder) 
      VALUES (0, -1, '[Main List]', 1, NULL, 0, 0);''';

  static final  String insertFirstList = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
      VALUES (1, 0, 'First List', 1, NULL, 0, 0);''';

  static final  String insertFirstItem = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
      VALUES (2, 1, 'First List Item', 0, NULL, 0, 0);'''; 

  static final  String insertSecondList = '''
    INSERT INTO lists (thingID, parentThingID, label, isList, icon, isMarked, sortOrder)
      VALUES (3, 0, 'Second List', 0, NULL, 0, 1);''';   
}