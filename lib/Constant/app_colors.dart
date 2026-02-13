import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

const Color blackColor= Colors.black;
const Color greyColor = Colors.grey;
const Color whiteColor = Colors.white;
const Color transparentColor = Colors.transparent;
const Color redColor = Colors.red;
final Color? textFieldColor = Colors.grey[900];

//theme text color:
class AppThemeHelper {
  static Color textColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.color!;
  }

  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color reverseTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? Colors.black
        : Colors.white;
  }
}