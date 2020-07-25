import 'package:flutter/material.dart';

class RouteThing {
  final ValueKey  key;
  final int       thingID;
  final IconData  icon;
  final bool      isShowListPage;

  RouteThing([ this.key, this.thingID, this.icon, this.isShowListPage ]);
}