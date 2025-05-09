import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// This class defines the theme for the StitchPal app
class StitchPalTheme {
  // Modern, refined color palette
  static const Color primaryColor = Color(0xFFE8A598); // Coral peach - more vibrant
  static const Color secondaryColor = Color(0xFF9ECEC3); // Sage green - more defined
  static const Color accentColor = Color(0xFFF6C9A0); // Warm amber - more vibrant
  static const Color backgroundColor = Color(0xFFFFFAF5); // Warm white - lighter
  static const Color textColor = Color(0xFF3D3A41); // Deep charcoal - darker for contrast
  static const Color errorColor = Color(0xFFE57373); // Soft red
  
  // Accent colors for UI elements
  static const Color successColor = Color(0xFF81C784); // Soft green for success states
  static const Color infoColor = Color(0xFF64B5F6); // Soft blue for info states
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure white for cards
  static const Color dividerColor = Color(0xFFEEEAE6); // Subtle divider
  
  // Tag-based color accents - more vibrant
  static const Color babyColor = Color(0xFF90CAF9); // Brighter blue for baby items
  static const Color holidayColor = Color(0xFFEF9A9A); // Brighter red for holiday items
  static const Color homeColor = Color(0xFFCE93D8); // Brighter lavender for home items
  static const Color summerColor = Color(0xFF81C784); // Brighter green for summer items
  static const Color winterColor = Color(0xFF90CAF9); // Brighter blue for winter items
  
  // Alternative background colors - more refined
  static const Color bgBeige = Color(0xFFF9F5EB); // Lighter beige
  static const Color bgPink = Color(0xFFFFF0F5); // Lighter pink
  static const Color bgLavender = Color(0xFFF5F0FA); // Lighter lavender

  // Utility method to safely handle opacity for colors
  static Color safeOpacity(Color color, double opacity) {
    return Color.fromRGBO(
      color.red,
      color.green,
      color.blue,
      opacity,
    );
  }

  // Utility method to safely handle alpha for colors
  static Color safeAlpha(Color color, double alphaPercent) {
    return Color.fromRGBO(
      color.red,
      color.green,
      color.blue,
      alphaPercent,
    );
  }
  
  // Get color for a specific tag
  static Color getTagColor(String tag) {
    switch (tag.toLowerCase()) {
      case 'baby':
      case 'infant':
        return babyColor;
      case 'holiday':
      case 'christmas':
      case 'halloween':
        return holidayColor;
      case 'home':
      case 'decor':
        return homeColor;
      case 'summer':
      case 'beach':
        return summerColor;
      case 'winter':
      case 'scarf':
      case 'hat':
        return winterColor;
      default:
        return accentColor;
    }
  }
  
  // Material 3 theme data with enhanced styling
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: textColor,
        onTertiary: textColor,
        onSurface: textColor,
        onBackground: textColor,
        onError: Colors.white,
        surfaceTint: primaryColor.withOpacity(0.05),
      ),
      
      // Enhanced typography with mixed serif and sans-serif
      textTheme: TextTheme(
        // Display styles - use Playfair Display for elegant headings
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.25,
          height: 1.3,
        ),
        
        // Headline styles - use Merriweather for warm, readable headings
        headlineLarge: GoogleFonts.merriweather(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0,
          height: 1.4,
        ),
        headlineMedium: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0,
          height: 1.4,
        ),
        headlineSmall: GoogleFonts.merriweather(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0,
          height: 1.4,
        ),
        
        // Body styles - use Nunito Sans for better readability on mobile
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor,
          letterSpacing: 0.15,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textColor,
          letterSpacing: 0.25,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textColor,
          letterSpacing: 0.4,
          height: 1.5,
        ),
        
        // Label styles for buttons and interactive elements
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.1,
          height: 1.4,
        ),
        labelMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.5,
          height: 1.4,
        ),
      ),
      
      // Apply Material 3 principles with rounded corners and shadows
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceColor,
        shadowColor: primaryColor.withOpacity(0.2),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        clipBehavior: Clip.antiAlias,
      ),
      
      // Button themes - more tactile and modern
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return primaryColor.withOpacity(0.8); // Deeper press effect
              }
              if (states.contains(WidgetState.hovered)) {
                return primaryColor.withOpacity(0.9); // Subtle hover effect
              }
              return primaryColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return Colors.white; // White text for better contrast
            },
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return 0; // Flat when pressed
              }
              return 2; // Subtle elevation for depth
            },
          ),
          shadowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return primaryColor.withOpacity(0.3);
            },
          ),
          padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
            (Set<WidgetState> states) {
              return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
            },
          ),
          shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
            (Set<WidgetState> states) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Slightly rounded corners
              );
            },
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              return GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              );
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withOpacity(0.1); // Subtle hover effect
              }
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withOpacity(0.2); // Press effect
              }
              return Colors.transparent;
            },
          ),
          // Add animation for a more polished feel
          animationDuration: const Duration(milliseconds: 150),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return primaryColor.withOpacity(0.7);
              }
              return primaryColor;
            },
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              return GoogleFonts.nunitoSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              );
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered) || 
                  states.contains(WidgetState.pressed)) {
                return primaryColor.withOpacity(0.1);
              }
              return Colors.transparent;
            },
          ),
          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        ),
      ),
      
      // Input decoration - cleaner, more modern look
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        hoverColor: primaryColor.withOpacity(0.04),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: textColor.withOpacity(0.5),
          fontWeight: FontWeight.w400,
        ),
        // Add subtle animation for focus transitions
        floatingLabelStyle: GoogleFonts.nunitoSans(
          color: primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Chip theme - more refined and tactile
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        disabledColor: dividerColor.withOpacity(0.5),
        selectedColor: primaryColor.withOpacity(0.15),
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        secondaryLabelStyle: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        brightness: Brightness.light,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: dividerColor),
        ),
        shadowColor: primaryColor.withOpacity(0.2),
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: backgroundColor,
      
      // App bar - more modern and refined
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        shadowColor: primaryColor.withOpacity(0.1),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: textColor),
        actionsIconTheme: IconThemeData(color: primaryColor),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 24,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textColor.withOpacity(0.5),
        selectedLabelStyle: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunitoSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
