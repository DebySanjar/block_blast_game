import 'package:flutter/material.dart';
import '../config/colors.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final titleFontSize = isSmallScreen ? 40.0 : 48.0;
    final subtitleFontSize = isSmallScreen ? 48.0 : 56.0;
    
    return Scaffold(
      backgroundColor: GameColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        Text(
                          'Block',
                          style: TextStyle(
                            color: GameColors.textPrimary,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          'Lock',
                          style: TextStyle(
                            color: GameColors.buttonColor,
                            fontSize: subtitleFontSize,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),
                  _buildMenuButton(
                    context,
                    'Boshlash',
                    Icons.play_arrow,
                    () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const GameScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                    size,
                  ),
                  SizedBox(height: size.height * 0.025),
                  _buildMenuButton(
                    context,
                    'Qoidalar',
                    Icons.help_outline,
                    () => _showRulesDialog(context),
                    size,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed,
    Size size,
  ) {
    final isSmallScreen = size.width < 360;
    final buttonWidth = size.width * 0.7;
    final fontSize = isSmallScreen ? 20.0 : 24.0;
    final iconSize = isSmallScreen ? 24.0 : 28.0;
    
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: GameColors.buttonColor,
          foregroundColor: GameColors.textPrimary,
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.08,
            vertical: size.height * 0.02,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showRulesDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final fontSize = isSmallScreen ? 14.0 : 16.0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: GameColors.boardBackground,
        title: const Text(
          'O\'yin qoidalari',
          style: TextStyle(color: GameColors.textPrimary),
        ),
        content: SingleChildScrollView(
          child: Text(
            '1. Pastdagi bloklarni tanlang\n\n'
            '2. Bloklarni taxtaga joylashtiring\n\n'
            '3. To\'liq qator yoki ustunni to\'ldiring\n\n'
            '4. To\'liq qator/ustun avtomatik tozalanadi\n\n'
            '5. Ball to\'plang va darajani oshiring\n\n'
            '6. Bloklar joylanmaguncha o\'ynang!',
            style: TextStyle(
              color: GameColors.textSecondary,
              fontSize: fontSize,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Tushunarli',
              style: TextStyle(
                color: GameColors.buttonColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
