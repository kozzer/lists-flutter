import 'package:flutter/material.dart';

class ListThing {
  final int             listID;
  final String          label;
  final bool            isMarked;    // Is this 'marked', ie has the user tapped it to fade the text marking it 'done'
  final Icon            icon;
  final bool            isList;      // Is this itself a list, or just an item in a parent list?
  final List<ListThing> _listItems;

  ListThing({
    @required this.listID,
    @required this.label,
    @required this.isMarked,
    this.icon,
    this.isList,
    this._listItems
  });

  int get ListSize => _listItems.length;
}