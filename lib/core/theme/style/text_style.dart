import 'package:flutter/material.dart';

class AppTextStyle {
  // Bold Text Style
  static const TextStyle boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: Colors.black, // Default text color
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    color: Colors.black, // Default text color
  );
  static const TextStyle heading = TextStyle(
    fontSize: 18,
    color: Colors.black, // Default text color
  );

  // Extra Large Text Style
  static const TextStyle xLarge = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Large Text Style
  static const TextStyle large = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Medium Text Style
  static const TextStyle medium = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  // Regular Text Style
  static const TextStyle regular = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // Small Text Style
  static const TextStyle small = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // Extra Small Text Style
  static const TextStyle xSmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  // Light Text Style
  static const TextStyle lightTextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16.0,
    color: Colors.black,
  );

  // Italic Text Style
  static const TextStyle italicTextStyle = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 16.0,
    color: Colors.black,
  );

  // Colored Text Style (with a custom color)
  static TextStyle coloredTextStyle(Color color) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }
}
