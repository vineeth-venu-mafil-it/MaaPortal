import 'package:flutter/material.dart';
import '../../utils/config/styles/colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'poppinsRegular',
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(8.0),
      thumbColor: WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
    ),
    useMaterial3: false,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      titleLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 16.0, fontFamily: 'poppinsRegular'),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'poppinsRegular'),
      labelLarge: TextStyle(fontSize: 14.0, fontFamily: 'poppinsSemiBold'),
    ),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: _headTxtStyle,
      dataRowColor: WidgetStateProperty.all(Colors.white),
      dataTextStyle: _tableRowTxtStyle,
      dividerThickness: 0,
      headingRowColor: WidgetStatePropertyAll(AppColor.drawerImgTileColor),
      headingRowHeight: 30,
      dataRowHeight: 30,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: Colors.black87,
    fontFamily: 'poppinsRegular',
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(8.0),
      thumbColor: WidgetStateProperty.all(Colors.red),
    ),
    useMaterial3: false,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
          fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(
          fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
      titleLarge: TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: TextStyle(
          fontSize: 16.0, fontFamily: 'poppinsRegular', color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 14.0, fontFamily: 'poppinsRegular', color: Colors.white),
      labelLarge: TextStyle(
          fontSize: 14.0, fontFamily: 'poppinsSemiBold', color: Colors.white),
    ),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: _headTxtStyle.copyWith(color: Colors.white),
      dataRowColor: WidgetStateProperty.all(Colors.black87),
      dataTextStyle: _tableRowTxtStyle.copyWith(color: Colors.white),
      dividerThickness: 0,
      headingRowColor:
          const WidgetStatePropertyAll(AppColor.drawerImgTileColor),
      headingRowHeight: 30,
      dataRowHeight: 30,
    ),
  );

  static const _headTxtStyle = TextStyle(
    fontFamily: 'poppinsRegular',
    fontSize: 10,
    color: AppColor.primaryColor,
  );

  static const _tableRowTxtStyle = TextStyle(
    fontFamily: 'poppinsRegular',
    fontSize: 10,
    color: AppColor.cardTitleSubColor,
  );
}
