import 'package:flutter/material.dart';

class ResponsiveHelper {
  final BuildContext context;
  
  ResponsiveHelper(this.context);
  
  // Screen dimensions
  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
  
  // Device types
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;
  
  // Responsive spacing
  double spacing(double percentage) => screenWidth * percentage;
  double verticalSpacing(double percentage) => screenHeight * percentage;
  
  // Responsive font sizes
  double fontSize({
    double mobile = 14,
    double? tablet,
    double? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile * 1.3;
    if (isTablet) return tablet ?? mobile * 1.15;
    return mobile;
  }
  
  // Grid columns based on screen size
  int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }
  
  // Responsive padding
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
    horizontal: screenWidth * 0.04,
  );
  
  EdgeInsets get allPadding => EdgeInsets.all(screenWidth * 0.04);
  
  // Responsive sizes
  double get cardBorderRadius => screenWidth * 0.035;
  double get buttonHeight => screenHeight * 0.06;
  double get iconSize => screenWidth * 0.06;
  double get smallIconSize => screenWidth * 0.04;
}
