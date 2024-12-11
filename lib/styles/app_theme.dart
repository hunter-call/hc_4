import 'package:flutter/material.dart';

class AppTheme {
  // Текстовые стили
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    height: 1.125, // 36px line height
    fontWeight: FontWeight.bold,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 20,
    height: 1.2, // 24px line height
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.25, // 20px line height
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    height: 1.38, // 18px line height
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 11,
    height: 1.09, // 12px line height
    fontWeight: FontWeight.normal,
  );

  // Цветовые стили
  static const Color background = Color.fromARGB(255, 26, 23, 36);
  static const Color primary = Color(0xffFF5D67);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFDFDEE4);
  static const Color surface = Color.fromRGBO(51, 50, 59, 0.404);
  static const Color surface2 = Color(0xFF3C3C3E);
  static const Color menu = Color(0xFF4A4A4C);
  static const Color gradient = Color(0xFF1A237E);
  static const Color outline = Color(0xFFBDBDBD);

  // Пример градиента (опционально)
  static const Gradient customGradient = LinearGradient(
    colors: [gradient, surface],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Метод для применения темы к виджету
}
