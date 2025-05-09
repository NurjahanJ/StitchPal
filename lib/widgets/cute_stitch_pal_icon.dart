import 'package:flutter/material.dart';
import 'package:stitchpal/theme.dart';

class CuteStitchPalIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const CuteStitchPalIcon({
    super.key,
    this.size = 24.0,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? StitchPalTheme.primaryColor;
    final bgColor = backgroundColor ?? Colors.white;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: StitchPalTheme.primaryColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Robot face
          Container(
            width: size * 0.85,
            height: size * 0.85,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
          ),
          
          // Eyes
          Positioned(
            top: size * 0.3,
            left: size * 0.25,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: size * 0.1,
                  height: size * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          
          Positioned(
            top: size * 0.3,
            right: size * 0.25,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: size * 0.1,
                  height: size * 0.1,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          
          // Smile
          Positioned(
            bottom: size * 0.25,
            child: Container(
              width: size * 0.4,
              height: size * 0.2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size * 0.2),
                  bottomRight: Radius.circular(size * 0.2),
                ),
              ),
            ),
          ),
          
          // Yarn detail
          Positioned(
            top: size * 0.05,
            right: size * 0.1,
            child: Container(
              width: size * 0.15,
              height: size * 0.15,
              decoration: BoxDecoration(
                color: StitchPalTheme.accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
