import 'package:flutter/material.dart';

class UserSettings {
  final bool    showListItemNumbers;
  final int     fontSize;
  final bool    useFloatingActionButton;
  final String  dataBackupLocation;

  UserSettings({
    this.showListItemNumbers,
    this.fontSize,
    this.useFloatingActionButton,
    this.dataBackupLocation
  })
}