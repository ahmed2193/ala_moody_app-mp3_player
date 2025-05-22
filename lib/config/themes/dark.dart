import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

ThemeData darkTheme() => ThemeData(
      useMaterial3: true,
      primaryIconTheme: const IconThemeData(
        color: AppColors.cIconDark,
      ),
      drawerTheme:const DrawerThemeData(backgroundColor: Colors.black) ,
        bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.black, // Removes default white background
    modalBackgroundColor: Colors.black, // Allow gradient
    shape: RoundedRectangleBorder(
    ),
  ),

    dialogTheme: DialogTheme(
    backgroundColor: Colors.black, // Ensure full customization
    surfaceTintColor: Colors.black, // Prevents unwanted overlay
    elevation: 10.0, // Gives a subtle shadow effect
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  ),
  
      iconTheme: const IconThemeData(color: AppColors.cIconDark),
      dividerTheme: const DividerThemeData(color: AppColors.cDividerDark),
      tabBarTheme: const TabBarTheme(
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.transparent,
  indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.transparent),
        ),      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: AppColors.cAppBarTextDark,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
        elevation: 0.0,
        backgroundColor: AppColors.cAppBarDark,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        iconTheme: IconThemeData(
          color: AppColors.cAppBarIconDark,
        ),
      ),
       dialogBackgroundColor: Colors.black,
      primarySwatch: AppColors.cPrimary,
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
        labelLarge: TextStyle(color: AppColors.cTextButtonDark),
        bodySmall: TextStyle(),
        displayMedium: TextStyle(),
        displaySmall: TextStyle(),
        headlineMedium: TextStyle(),
        headlineSmall: TextStyle(),
        labelSmall: TextStyle(),
        titleMedium: TextStyle(),
        titleSmall: TextStyle(),
      ).apply(
        bodyColor: AppColors.cTextDark,
        displayColor: Colors.blue,
      ),
      cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
        barBackgroundColor: AppColors.cPrimary,
        brightness: Brightness.dark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        unselectedIconTheme:
            IconThemeData(size: 30.0, color: AppColors.cUnSelectedIconDark),
        selectedIconTheme:
            IconThemeData(size: 30.0, color: AppColors.cSelectedIcon),
        backgroundColor: AppColors.cBottomBarDark,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 8.0,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.cSelectedIcon,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.cUnSelectedIconDark,
        ),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      scaffoldBackgroundColor: AppColors.cScaffoldBackgroundColorDark,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.cPrimary,
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.cTextDark,
        textColor: AppColors.cTextDark,
        selectedColor: AppColors.cSelectedIcon,
      ),
    );
