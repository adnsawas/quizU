import 'package:flutter/material.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: ColorScheme.fromSwatch(
      primaryColorDark: AppColors.backgroundColor,
      backgroundColor: AppColors.backgroundColor,
      cardColor: AppColors.cardBackgroundColor,
      brightness: Brightness.dark,
      accentColor: AppColors.secondaryColor,
    ),
    backgroundColor: AppColors.backgroundColor,
    cardColor: AppColors.cardBackgroundColor,
    cardTheme: const CardTheme(
      elevation: 0,
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
    ),
    // dialogBackgroundColor: AppColors.cardBackgroundColor,
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.cardBackgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
    ),
    dividerColor: AppColors.primaryColor,
    indicatorColor: AppColors.primaryColor,
    navigationBarTheme: const NavigationBarThemeData(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
    ),
    canvasColor: AppColors.smallItemsBackgroundColor,
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
        minimumSize: MaterialStateProperty.all(const Size(160, 50)),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)))),
        textStyle:
            MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(const Size(160, 50)),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
          side: const MaterialStatePropertyAll(BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          )),
          overlayColor: MaterialStatePropertyAll(
              AppColors.primaryColor.withOpacity(0.25)),
          textStyle:
              MaterialStateProperty.all(Theme.of(context).textTheme.headline6),
          foregroundColor: const MaterialStatePropertyAll(Colors.white)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.secondaryColor))),
  );
}
