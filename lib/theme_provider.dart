import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:quranku/core/constants/hive_constants.dart';

import 'core/utils/themes/color_schemes.dart';

@singleton
class ThemeProvider with ChangeNotifier {
  late ThemeMode _themeMode = ThemeMode.system;
  late ColorScheme _darkScheme = darkColorScheme;
  late ColorScheme _lightScheme = lightColorScheme;
  late bool _dynamicColor = false;

  void init() {
    getDynamicColor();
    getThemeMode();
  }

  bool get dynamicColor => _dynamicColor;

  void setDynamicColor(bool value) {
    try {
      var box = Hive.box(HiveBoxConst.themeModeBox);
      const key = HiveKeyConst.dynamicColorKey;
      box.put(key, value);
      _dynamicColor = value;
      notifyListeners();
    } catch (e) {
      _dynamicColor = false;
    }
    notifyListeners();
  }

  void getDynamicColor() async {
    try {
      var box = await Hive.openBox(HiveBoxConst.themeModeBox);
      const key = HiveKeyConst.dynamicColorKey;
      final bool dynamicColor = box.get(key, defaultValue: false);
      _dynamicColor = dynamicColor;
      notifyListeners();
    } catch (e) {
      _dynamicColor = false;
    }
    notifyListeners();
  }

  void getThemeMode() async {
    var box = await Hive.openBox(HiveBoxConst.themeModeBox);
    const key = HiveKeyConst.themeModeKey;
    final String themeMode = box.get(key, defaultValue: ThemeMode.system.name);
    if (themeMode == ThemeMode.system.name) {
      _themeMode = ThemeMode.system;
    } else if (themeMode == ThemeMode.light.name) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    _themeMode = value;
    var box = Hive.box(HiveBoxConst.themeModeBox);
    const key = HiveKeyConst.themeModeKey;
    box.put(key, value.name);
    notifyListeners();
  }

  ColorScheme get darkScheme => _darkScheme;

  void setDarkScheme(ColorScheme value) {
    _darkScheme = value;
    notifyListeners();
  }

  ColorScheme get lightScheme => _lightScheme;

  void setLightScheme(ColorScheme value) {
    _lightScheme = value;
    notifyListeners();
  }
}
