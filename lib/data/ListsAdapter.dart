import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lists/models/ListThing.dart';

class ListsAdapter {

  // Constructor, singleton access
  ListsAdapter._();
  static final ListsAdapter instance = ListsAdapter._();

  // Database info
  static const String _databaseFileName = 'lists_database.db';
  static const int    _databaseVersion  = 1;

  // Table/column names
  static const String listsTable        = 'lists';
  static const String colThingID        = 'thingID';      
  static const String colParentThingID  = 'parentThingID';
  static const String colLabel          = 'label';
  static const String colIsList         = 'isList';
  static const String colIcon           = 'icon';
  static const String colIsMarked       = 'isMarked';
  static const String colSortOrder      = 'sortOrder';

 // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    // If _database is null, get it now, then return the instance
    print('KOZZER - ListsAdapter: get database');

    // init database if null, then return it
    _database ??= await _initDatabase();
    return _database;
  }

    // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {

    final String path = join(await getDatabasesPath(), _databaseFileName);

    // Delete database so it can be re-generated with canned queries
    //await deleteDatabaseFile(path);
   
    print('KOZZER - in _initDatabase(), about to open $path');
    final Database db = await openDatabase(
        path,
        version:  _databaseVersion,
        onCreate: _onCreate,
        readOnly: false);

    // DEBUG - just report # of rows in table
    final List<Map<String, dynamic>> num = await db.rawQuery('SELECT * FROM lists');
    num.forEach((row) { row.forEach((String key, dynamic value) {print('KOZZER - $key -- $value');}); });

    return db;
  }

  // SQL code to create the database table & rows
  Future<void> _onCreate(Database db, int version) async {
    print('KOZZER - creating new database');
    await db.execute(createDatabaseSQL);
    await db.execute(insertMainList);
    await db.execute(insertFirstList);
    await db.execute(insertFirstItem);
    await db.execute(insertSecondList);
    await db.execute(insertThirdList);
  }

  /// Insert new ListThing into database (since it's an add, it will never have any children at this point)
  Future<int> insert(ListThing thing) async {
    print('KOZZER - get new thing id');
    final Database db = await instance.database;   
    final String query = "SELECT MAX(thingID) + 1 FROM lists";
    var row = await db.rawQuery(query);
    var newID = row[0].values.first as int;
    var newThing = ListThing(newID,
                             thing.parentThingID,
                             thing.label,
                             thing.isList,
                             thing.icon,
                             thing.isMarked,
                             thing.sortOrder);

    print('KOZZER - insert new thing row: ${newThing.toMap()}');
    return await db.insert(listsTable, newThing.toMap());
  }

  /// Delete ListThing from database, including all descendants (uses recursion)
  Future<void> delete(int thingID) async {
    print('KOZZER - in ListsDataProvider.delete($thingID)');

    // Get any children
    final Database db = await instance.database;
    String query = 'SELECT $colThingID FROM $listsTable WHERE $colParentThingID = $thingID';
    final List<Map<String, dynamic>> rows = await db.rawQuery(query);

    if (rows.isNotEmpty){
      print('KOZZER - in ListsDataProvider.delete($thingID) - found ${rows.length} children');
      // Recursively get to the "bottom", and then we can delete on the way up
      for (final Map<String, dynamic> row in rows){
        final int childID = row[colThingID] as int;
        // Call this method recursively
        print('KOZZER - calling ListsDataProvider.delete($childID) recursively');
        await delete(childID);
      }

      // Descendants should all be deleted, so now delete primary thing
      print('KOZZER - deleting thing ID $thingID');
      query = 'DELETE FROM $listsTable WHERE $colThingID = $thingID';
      await db.rawQuery(query);
    }
  }

  /// Update existing ListThing record
  Future<int> update(ListThing thing) async {
    print('KOZZER - updating thing row - new values: ${thing.toMap()}');
    final Database db = await instance.database;
    return await db.update(listsTable, thing.toMap());
  }

  /// Gets ListThing by ID and includes all descendants
  Future<ListThing> getListThingByID(int thingID) async {

    print('KOZZER - in listsAdapter.getListThingByID($thingID)');
    // Build SQL query
    final Database db = await instance.database;
    final String query = '''SELECT $colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder
                            FROM   $listsTable
                            WHERE  $colThingID = $thingID;''';
    // Execute query (should only get 1 item)
    final List<Map<String, dynamic>> rows = await db.rawQuery(query);   
    if(rows?.length == 1){

      // Convert map to ListThing object
      final ListThing thing = ListThing.fromMap(rows[0]);

      // If this is a list, get the children
      if (thing.isList){
        final List<ListThing> children = await getChildrenForParentID(thing.thingID);
        print('KOZZER - found ${children?.length ?? 0} children');

        for(int i = 0; i < children.length; i++){
          thing.addChildThing(children[i]);
        }
      }
      // Return populated thing
      return thing;
      
    } else {
      throw 'bad thing id';  // We definitely should have 1 record, no more, no less
    }                 
  }

  /// Gets all children ListThings for given thingID, executes recursively to get descendants
  Future<List<ListThing>> getChildrenForParentID(int parentID) async {

    // Build SQL query
    final Database db = await instance.database;
    final String query = '''SELECT $colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder
                            FROM   $listsTable
                            WHERE  $colParentThingID = $parentID;''';
    // Execute query
    final List<Map<String, dynamic>> rows = await db.rawQuery(query);

    // Loop through any results and populate list
    final List<ListThing> children = <ListThing>[];
    for(final Map<String, dynamic> row in rows){

      final ListThing child = ListThing.fromMap(row);

      if (child.isList){
        final List<ListThing> grandChildren = await getChildrenForParentID(child.thingID);
        for (int i = 0; i < grandChildren.length; i++){
          child.addChildThing(grandChildren[i]);
        }
      }
      children.add(child);
    }

    return children;
  }

  Future<void> deleteDatabaseFile(String path) async {
    // DELETE DATABASE FILE Needs directive: import 'dart:io';
    if (_database == null){
      print('KOZZER - deleting existing database file: $path');
      final File fse = File(path);
      if (await fse.exists()){
        fse.delete();
      }
    }
  }

// SQL Queries
static const String createDatabaseSQL = '''
  CREATE TABLE $listsTable (
    $colThingID         INTEGER   PRIMARY KEY,
    $colParentThingID   INTEGER   NOT NULL,
    $colLabel           TEXT      NOT NULL,
    $colIsList          INTEGER   NOT NULL,
    $colIcon            TEXT,
    $colIsMarked        INTEGER   NOT NULL,
    $colSortOrder       INTEGER   NOT NULL
  );''';

static const  String insertMainList = '''
  INSERT INTO $listsTable ($colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder) 
    VALUES (0, -1, '[Main List]', 1, NULL, 0, 0);''';

static const  String insertFirstList = '''
  INSERT INTO $listsTable ($colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder)
    VALUES (1, 0, 'First List', 1, NULL, 0, 0);''';

static const  String insertFirstItem = '''
  INSERT INTO $listsTable ($colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder)
    VALUES (2, 1, 'First List Item', 0, NULL, 0, 0);'''; 

static const String insertSecondList = '''
  INSERT INTO $listsTable ($colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder)
    VALUES (3, 0, 'Second List', 1, NULL, 0, 1);''';  

static const String insertThirdList = '''
  INSERT INTO $listsTable ($colThingID, $colParentThingID, $colLabel, $colIsList, $colIcon, $colIsMarked, $colSortOrder)
    VALUES (4, 0, 'Third List', 1, NULL, 0, 2);''';   
}


