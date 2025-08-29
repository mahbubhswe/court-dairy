import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static const _key = 'isDarkMode';

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  static void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }

  static bool _loadThemeFromBox() {
    return GetStorage().read(_key) ?? false;
  }

  static void _saveThemeToBox(bool isDarkMode) {
    GetStorage().write(_key, isDarkMode);
  }
}
