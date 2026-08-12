import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum DeviceType { mobile, tablet, desktop }

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  DeviceType get deviceType {
    final width = screenWidth;
    if (width >= AppConstants.breakpointTablet) return DeviceType.desktop;
    if (width >= AppConstants.breakpointMobile) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;

  /// Max content width for centered layouts on large screens — prevents
  /// dashboards/forms from stretching edge-to-edge on desktop/web.
  double get maxContentWidth => isDesktop ? 1200 : double.infinity;
}

extension StringValidation on String {
  bool get isValidEmail =>
      RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(trim());
}
