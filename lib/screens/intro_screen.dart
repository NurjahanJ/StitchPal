import 'dart:math';
import 'package:flutter/material.dart';
import 'package:stitchpal/main.dart';
import 'package:stitchpal/theme.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    // Rotation animation
    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    // Scale animation
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Gradient background with pastel colors
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              StitchPalTheme.bgBeige,
              StitchPalTheme.bgPink,
              StitchPalTheme.bgLavender,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated yarn ball
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * pi,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: _buildYarnBallLogo(),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // App name
                    Text(
                      'StitchPal',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: StitchPalTheme.primaryColor,
                        shadows: [
                          Shadow(
                            color: StitchPalTheme.primaryColor.withAlpha(100),
                            blurRadius: 10,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Subtitle
                    Text(
                      'Your AI-Powered Crochet Companion',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(255, 163, 149, 149),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Start button
                    SizedBox(
                      width: 240,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the main app
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const MainNavigationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StitchPalTheme.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: StitchPalTheme.primaryColor.withAlpha(150),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 28,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 3,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Start a New Project',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Decorative yarn strand
                    _buildYarnStrand(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYarnBallLogo() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: StitchPalTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: StitchPalTheme.primaryColor.withAlpha(100),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Yarn texture
          ...List.generate(8, (index) {
            final angle = index * (pi / 4);
            return Positioned.fill(
              child: CustomPaint(
                painter: YarnTexturePainter(
                  angle: angle,
                  color: Colors.white.withAlpha(80),
                ),
              ),
            );
          }),
          
          // Center
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: StitchPalTheme.primaryColor.withAlpha(220),
              ),
              child: Center(
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYarnStrand() {
    return CustomPaint(
      size: const Size(300, 60),
      painter: YarnStrandPainter(
        color: StitchPalTheme.primaryColor,
      ),
    );
  }
}

class YarnTexturePainter extends CustomPainter {
  final double angle;
  final Color color;

  YarnTexturePainter({
    required this.angle,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Create a curved line across the yarn ball
    final path = Path();
    path.moveTo(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    // Control points for the curve
    final cp1 = Offset(
      center.dx + radius * 0.5 * cos(angle + pi / 4),
      center.dy + radius * 0.5 * sin(angle + pi / 4),
    );
    final cp2 = Offset(
      center.dx + radius * 0.5 * cos(angle - pi / 4),
      center.dy + radius * 0.5 * sin(angle - pi / 4),
    );

    path.cubicTo(
      cp1.dx, cp1.dy,
      cp2.dx, cp2.dy,
      center.dx + radius * cos(angle + pi),
      center.dy + radius * sin(angle + pi),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class YarnStrandPainter extends CustomPainter {
  final Color color;

  YarnStrandPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);

    // Create a wavy line
    for (int i = 0; i < 6; i++) {
      final x1 = size.width / 6 * i;
      final x2 = size.width / 6 * (i + 1);
      final y = i % 2 == 0 ? size.height / 3 : size.height * 2 / 3;
      
      path.quadraticBezierTo(
        (x1 + x2) / 2, y,
        x2, size.height / 2,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
