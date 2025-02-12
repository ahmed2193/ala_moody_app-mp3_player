import 'package:flutter/material.dart';

TextStyle? styleW400(
  BuildContext context, {
  double? fontSize,
  Color? color,
  double? height=0,
}) =>
    TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? 14,
      color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
      height: height,
    );

TextStyle? styleW500(
  BuildContext context, {
  double? fontSize,
  Color? color,
}) =>
    TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? 20,
      color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
    );

TextStyle? styleW600(
  BuildContext context, {
  double? fontSize,
  Color? color,
}) =>
    TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: fontSize ?? 18,
      color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
    );

TextStyle? styleW700(
  BuildContext context, {
  double? fontSize,
  Color? color,
    double? height=0,


}) =>
    TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: fontSize ?? 14,
      color: color ?? Theme.of(context).textTheme.bodyLarge!.color,
            height: height,

    );
