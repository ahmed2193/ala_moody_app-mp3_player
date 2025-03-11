import 'package:flutter/material.dart';

void pushNavigate(BuildContext context, Widget screen , {bool rootNavigator =false}) {
  Navigator.of(context, rootNavigator: rootNavigator,).push(
   
    MaterialPageRoute(
      builder: (context) => screen,
    ),
  );
}

void pushNavigateAndRemoveUntil(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => screen,
    ),
    (route) => false,
  );
}

