
class UserSettings {
  
  UserSettings({
    this.showListItemNumbers,
    this.fontSize,
    this.useFloatingActionButton,
    this.dataBackupLocation
  });

  final bool    showListItemNumbers;
  final int     fontSize;
  final bool    useFloatingActionButton;
  final String  dataBackupLocation;
}