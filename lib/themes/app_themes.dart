import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class AppThemes {
  static void updateSystemUIOverlay(bool isDarkTheme) {
    final statusBarColor =
        isDarkTheme ? AppColors.darkBackgroundColor : AppColors.primaryColor;
    final statusBarIconBrightness =
        isDarkTheme ? Brightness.light : Brightness.dark;
    final navigationBarColor =
        isDarkTheme ? AppColors.darkPrimaryColor : AppColors.backgroundColor;
    final navigationBarIconBrightness =
        isDarkTheme ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarIconBrightness: statusBarIconBrightness,
      systemNavigationBarColor: navigationBarColor,
      systemNavigationBarIconBrightness: navigationBarIconBrightness,
    ));
  }

  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: AppColors.primaryColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: AppColors.primaryColor,
      iconTheme: IconThemeData(color: AppColors.darkPrimaryColor),
      titleTextStyle: TextStyle(
        color: AppColors.darkPrimaryColor,
        fontSize: 21,
      ),
    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: AppColors.textColor),
      displayLarge: TextStyle(color: AppColors.textColor),
      bodyMedium: TextStyle(color: AppColors.textColor),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0.1,
      shadowColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColors.secondaryColor,
          width: 1,
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      titleTextStyle: const TextStyle(
        color: AppColors.textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.textColor,
        fontSize: 16,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.darkPrimaryColor,
      unselectedLabelColor: AppColors.darkSecondaryColor,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.darkPrimaryColor, width: 2.0),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryColor,
      foregroundColor: AppColors.darkSecondaryColor,
      elevation: 3.0,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: AppColors.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      color: AppColors.darkBackgroundColor,
      iconTheme: IconThemeData(color: AppColors.darkTextColor),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextColor,
        fontSize: 21,
      ),
    ),
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.darkTextColor),
      bodyMedium: TextStyle(color: AppColors.darkTextColor),
    ),
    cardTheme: CardTheme(
      elevation: 0.1,
      color: AppColors.darkPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColors.darkSecondaryColor,
          width: 1,
        ),
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.secondaryColor,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2.0),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkSecondaryColor,
      foregroundColor: AppColors.secondaryColor,
      elevation: 3.0,
    ),
  );
}
