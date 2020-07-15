import 'package:flutter/material.dart';  // For IconData class

class ListThing {

  ListThing(
    this.thingID,
    this.parentThingID,
    this.label,
    this.isList,
    [
      this.icon,
      this.isMarked  = false,
      this.sortOrder = 999999
    ]
  );

  ListThing.fromMap(Map<String, dynamic> map): 
    thingID        =  map['thingID']        as int,
    parentThingID  =  map['parentThingID']  as int,
    label          =  map['label']          as String,
    isList         = (map['isList']         as int        ) > 0,
    icon           =  IconData(map['icon']  as int, fontFamily: "MaterialIcons"),
    isMarked       = (map['isMarked']       as int        ) > 0,
    sortOrder      =  map['sortOrder']      as int;

  ValueKey get key => ValueKey(this.hashCode.toString());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thingID':        thingID,    // changed table def to autoincrement this
      'parentThingID':  parentThingID,
      'label':          label,
      'isList':         isListAsInt,
      'icon':           icon.codePoint,
      'isMarked':       isMarkedAsInt,
      'sortOrder':      sortOrderDbVal
    };
  }

  ListThing copyWith({int thingID, int parentThingID, String label, bool isList, IconData icon, bool isMarked, int sortOrder, List<ListThing> items}){
    var newThing = ListThing(
      thingID       ?? this.thingID,
      parentThingID ?? this.parentThingID,
      label         ?? this.label,
      isList        ?? this.isList,
      icon          ?? this.icon,
      isMarked      ?? this.isMarked,
      sortOrder     ?? this.sortOrder
    );

    var children = items ?? this._items;
    children.forEach((thing) {
      final copiedThing = thing.copyWith();
      newThing.addChildThing(copiedThing);
    });

    return newThing;
  }

  final int thingID;
  final int parentThingID;
  String    label;
  bool      isList;               // Is this itself a list, or just an item in a parent list?
  IconData  icon; 
  bool      isMarked;             // Is this 'marked', ie has the user tapped it to fade the text marking it 'done'
  int       sortOrder;            // Default to end of list
  final List<ListThing> _items = <ListThing>[];

  List<ListThing> get items        => _items;
  int             get listSize     => _items.length;
  int             get maxSortOrder => _items.last.sortOrder;
  bool            get showAsMarked => !isList && isMarked;

  int get isListAsInt    => isList    != null && isList   ? 1 : 0;
  int get isMarkedAsInt  => isMarked  != null && isMarked ? 1 : 0;
  int get sortOrderDbVal => sortOrder != null ?  sortOrder : 99999;

  ListThing getChildListThing(int index) => _items[index];

  void addChildThing(ListThing thing) {
    if (!isList){
      isList = true;    // Since we're adding an item, convert to list if not already one
    }
    _items.add(thing);
    _items.sort((ListThing a, ListThing b) => a.sortOrder.compareTo(b.sortOrder)); // Sorts in place after every add
  }

  void removeChildThing(ListThing thing) => _items.remove(thing);

  void clearChildThings() => _items.clear();

}
