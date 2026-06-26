import 'dart:math';
import 'package:flutter/material.dart';

class ResponsiveLayout {
  final Size screenSize;

  static const double baseWidth = 1920.0;
  static const double baseHeight = 1080.0;

  ResponsiveLayout(this.screenSize);

  static ResponsiveLayout of(BuildContext context) {
    return ResponsiveLayout(MediaQuery.of(context).size);
  }

  double get scaleWidth => screenSize.width / baseWidth;
  double get scaleHeight => screenSize.height / baseHeight;
  double get scale => min(scaleWidth, scaleHeight);

  double w(double width) => width * scaleWidth;
  double h(double height) => height * scaleHeight;
  double sp(double size) => size * scale;

  double get bodyMaxWidth => w(1600.0);
  double get contentPadding => sp(24.0);
  double get topGap => h(20.0);
  double get sectionGap => sp(24.0);
  double get bottomNavHorizontalPadding => w(48.0);
  double get sidePanelGap => w(16.0);
  double get largeTitleSize => sp(32.0);
  double get mediumTextSize => sp(18.0);
  double get iconSize => sp(20.0);
  double get iconXs => sp(28);
  double get iconSm => sp(36);
  double get iconMd => sp(48);
  double get iconLg => sp(64);
  double get iconXl => sp(100);

  double get paddingXs => sp(4.0);
  double get paddingSm => sp(8.0);
  double get paddingMd => sp(16.0);
  double get paddingLg => sp(24.0);
  double get paddingXl => sp(32.0);

  double get radiusSm => sp(8.0);
  double get radiusMd => sp(12.0);
  double get radiusLg => sp(16.0);
  double get radiusXl => sp(24.0);

  double get fontXs => sp(11.0);
  double get fontSm => sp(14.0);
  double get fontMd => sp(18.0);
  double get fontLg => sp(24.0);
  double get fontXl => sp(28.0);
  double get fontXxl => sp(32.0);

  EdgeInsets edgeInsetsAll(double v) => EdgeInsets.all(sp(v));
  EdgeInsets edgeInsetsSym({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: w(h), vertical: this.h(v));
  EdgeInsets edgeInsetsOnly({
    double l = 0, double t = 0, double r = 0, double b = 0,
  }) => EdgeInsets.fromLTRB(w(l), this.h(t), w(r), this.h(b));
}
