import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData lightTheme() => ThemeData(
      useMaterial3: true,

      primaryIconTheme: const IconThemeData(
        color: AppColors.cOffWhite,
      ),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        barBackgroundColor: AppColors.cPrimary,
        brightness: Brightness.light,
      ),
      iconTheme: const IconThemeData(color: AppColors.cIconLight),
      dividerTheme: const DividerThemeData(color: AppColors.cDividerLight),
      primarySwatch: AppColors.cPrimary,
       dialogTheme: const DialogTheme(
        backgroundColor: Colors.black, // Set the background color here
      ),
         tabBarTheme: const TabBarTheme(
          
     tabAlignment:TabAlignment.start ,
         indicatorColor: Colors.transparent,
  indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.transparent),
        ),        ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: AppColors.cAppBarTextLight,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        elevation: 0.0,
        backgroundColor: AppColors.lightGray,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        iconTheme: IconThemeData(
          color: AppColors.cAppBarIconLight,
        ),
      ),
      //primarySwatch: AppColors.cPrimary,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.cPrimary,
      ),
      fontFamily: 'Poppins',
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.fade,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(),
        displayLarge: TextStyle(),
        titleLarge: TextStyle(),
        labelLarge: TextStyle(color: AppColors.cTextButtonLight),
        bodySmall: TextStyle(),
        displayMedium: TextStyle(),
        displaySmall: TextStyle(),
        headlineMedium: TextStyle(),
        headlineSmall: TextStyle(),
        labelSmall: TextStyle(),
        titleMedium: TextStyle(),
        titleSmall: TextStyle(),
      ).apply(
        bodyColor: AppColors.cTextLight,
        displayColor: Colors.blue,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme: IconThemeData(size: 30.0, color: Colors.white),
        selectedIconTheme: IconThemeData(size: 30.0, color: Colors.white),
        backgroundColor: AppColors.cBottomBarLight,
        selectedItemColor: AppColors.cSelectedIcon,
        unselectedItemColor: AppColors.cUnSelectedIconLight,
        elevation: 8.0,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.cSelectedIcon,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.cUnSelectedIconLight,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cPrimary,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.cIconLight,
        textColor: AppColors.cTextLight,
        selectedColor: AppColors.cSelectedIcon,
      ),
    );
