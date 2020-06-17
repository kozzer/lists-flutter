import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ListThing {
  final int             listID;
  final int             parentListID;
        String          label;
        bool            isList;             // Is this itself a list, or just an item in a parent list?
        IconData        icon;
        bool            isMarked  = false;   // Is this 'marked', ie has the user tapped it to fade the text marking it 'done'
        int             sortOrder = 999999; // Default to end of list
  final List<ListThing> _items = [];

  List<ListThing> get items        => _items;
  int             get listSize     => _items.length;
  int             get maxSortOrder => _items.last.sortOrder;

  ListThing({
    @required this.listID,
    @required this.parentListID,
    @required this.label,
    @required this.isList,
    this.icon
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

  Map<String, dynamic> toMap() {
    return {
      'listID':       listID,
      'parentListID': parentListID,
      'label':        label,
      'isList':       isList,
      'icon':         icon,
      'isMarked':     isMarked,
      'sortOrder':    sortOrder
    };
  }
  
}