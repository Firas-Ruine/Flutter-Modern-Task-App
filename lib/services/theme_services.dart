import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
//Initialize fields
  final _box = GetStorage();
  final _key = 'isDarkMode';

//Save the current theme function
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

//Load theme function
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

//Switch between theme function
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
