import 'package:flutter/material.dart';

class GameColors {
  // Asosiy ranglar - ko'k + yashil tema
  static const Color background = Color(0xFF0A1828);
  static const Color boardBackground = Color(0xFF1A2332);
  static const Color emptyCell = Color(0xFF253447);
  
  // Blok ranglari - ko'k va yashil ohanglari
  static const Color block1 = Color(0xFF2E8B9E); // Ko'k-yashil
  static const Color block2 = Color(0xFF3FA796); // Yashil-ko'k
  static const Color block3 = Color(0xFF4FB3A8); // Ochiq yashil
  static const Color block4 = Color(0xFF5BC0BE); // Turkuaz
  static const Color block5 = Color(0xFF6FCDBD); // Yashil-ko'k
  
  // UI ranglari
  static const Color textPrimary = Color(0xFFE8F4F8);
  static const Color textSecondary = Color(0xFF9DB4C0);
  static const Color buttonColor = Color(0xFF3FA796);
  static const Color scoreBackground = Color(0xFF1A2332);
  
  // Splash screen ranglari
  static const Color splashBackground = Color(0xFF0A1828);
  static const Color splashAccent = Color(0xFF3FA796);
  
  // To'liq qator rangi - orange
  static const Color clearLineColor = Color(0xFFFF8C42);
  
  // Gradient ranglari - ko'k va yashil
  static const LinearGradient blockGradient1 = LinearGradient(
    colors: [Color(0xFF2E8B9E), Color(0xFF1F6B7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blockGradient2 = LinearGradient(
    colors: [Color(0xFF3FA796), Color(0xFF2D8577)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blockGradient3 = LinearGradient(
    colors: [Color(0xFF4FB3A8), Color(0xFF3A9188)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blockGradient4 = LinearGradient(
    colors: [Color(0xFF5BC0BE), Color(0xFF459E9C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blockGradient5 = LinearGradient(
    colors: [Color(0xFF6FCDBD), Color(0xFF54AB9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0A1828), Color(0xFF1A2E3F), Color(0xFF2E8B9E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient clearLineGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static List<LinearGradient> get blockGradients => [
    blockGradient1,
    blockGradient2,
    blockGradient3,
    blockGradient4,
    blockGradient5,
  ];
}
