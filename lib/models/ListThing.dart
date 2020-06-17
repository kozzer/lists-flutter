import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ListThing {
  final int listID;
  String    label;
  bool      isList;             // Is this itself a list, or just an item in a parent list?
  Icon      icon;
  bool      isMarked = false;   // Is this 'marked', ie has the user tapped it to fade the text marking it 'done'
  int       sortOrder = 0;
  final List<ListThing> _items = [];

  List<ListThing> get items => _items;
  int get listSize => _items.length;

  ListThing({
    @required this.listID,
    @required this.label,
    @required this.isList,
    this.icon,
    this.sortOrder
  });

  void add(ListThing thing) {
    if (!isList){
      isList = true;    // Since we're adding an item, convert to list if not already one
    }
    _items.add(thing);
  }

  void remove(ListThing thing){
    _items.remove(thing);
  }
}