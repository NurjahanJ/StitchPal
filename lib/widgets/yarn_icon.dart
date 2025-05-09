import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

/// A custom yarn ball icon widget
class YarnIcon extends StatelessWidget {
  final double size;
  final Color color;

  const YarnIcon({
    super.key,
    this.size = 28,
    this.color = StitchPalTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _YarnPainter(color: color),
    );
  }
}

class _YarnPainter extends CustomPainter {
  final Color color;

  _YarnPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the main yarn ball
    canvas.drawCircle(center, radius, paint);

    // Draw yarn details with slightly darker color
    final detailPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw curved lines to represent yarn texture
    final path1 = Path()
      ..moveTo(center.dx - radius * 0.7, center.dy - radius * 0.3)
      ..quadraticBezierTo(
        center.dx, 
        center.dy - radius * 0.8, 
        center.dx + radius * 0.7, 
        center.dy - radius * 0.3
      );
    
    final path2 = Path()
      ..moveTo(center.dx - radius * 0.6, center.dy)
      ..quadraticBezierTo(
        center.dx, 
        center.dy + radius * 0.6, 
        center.dx + radius * 0.6, 
        center.dy
      );
    
    final path3 = Path()
      ..moveTo(center.dx - radius * 0.5, center.dy + radius * 0.4)
      ..quadraticBezierTo(
        center.dx - radius * 0.1, 
        center.dy - radius * 0.4, 
        center.dx + radius * 0.5, 
        center.dy + radius * 0.4
      );

    canvas.drawPath(path1, detailPaint);
    canvas.drawPath(path2, detailPaint);
    canvas.drawPath(path3, detailPaint);
    
    // Draw a small thread coming out
    final threadPath = Path()
      ..moveTo(center.dx + radius * 0.8, center.dy - radius * 0.6)
      ..quadraticBezierTo(
        center.dx + radius * 1.2, 
        center.dy - radius * 0.8, 
        center.dx + radius * 1.0, 
        center.dy - radius * 1.0
      );
    
    canvas.drawPath(threadPath, detailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
