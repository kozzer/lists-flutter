import 'package:flutter/material.dart';


class ListThing {

  ListThing(
    this.thingID,
    this.parentThingID,
    this.label,
    this.isList,
    {
      this.icon,
      this.isMarked,
      this.sortOrder
    }
  );

  ListThing.fromMap(Map<String, dynamic> map): 
    thingID        =  map['thingID']        as int,
    parentThingID  =  map['parentThingID']  as int,
    label          =  map['label']          as String,
    isList         = (map['isList']         as int        ) > 0,
    icon           =  map['icon']           as IconData,
    isMarked       = (map['isMarked']       as int        ) > 0,
    sortOrder      =  map['sortOrder']      as int;


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'thingID':        thingID,
      'parentThingID':  parentThingID,
      'label':          label,
      'isList':         isList,
      'icon':           icon,
      'isMarked':       isMarked,
      'sortOrder':      sortOrder
    };
  }

  final int             thingID;
  final int             parentThingID;
  String                label;
  bool                  isList;              // Is this itself a list, or just an item in a parent list?
  IconData              icon;
  bool                  isMarked  = false;   // Is this 'marked', ie has the user tapped it to fade the text marking it 'done'
  int                   sortOrder = 999999;  // Default to end of list
  final List<ListThing> _items = <ListThing>[];

  List<ListThing> get items        => _items;
  int             get listSize     => _items.length;
  int             get maxSortOrder => _items.last.sortOrder;
  bool            get showAsMarked => !isList && isMarked;

  ListThing getChildListThing(int index) => _items[index];

  void addChildThing(ListThing thing) {
    if (!isList){
      isList = true;    // Since we're adding an item, convert to list if not already one
    }
    _items.add(thing);
  }

  void removeChildThing(ListThing thing) => _items.remove(thing);

}
