
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class ListsDragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return ReorderableListener(
      child: Container(
        padding: EdgeInsets.only(right: 10.0, left: 10.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Icon(
            Icons.drag_handle, 
            color: Theme.of(context).textTheme.bodyText2.color
          ),
        ),
      ),
    );
  }
}