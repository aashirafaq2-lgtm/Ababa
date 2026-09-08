import 'package:flutter/material.dart';

class ServiceItem {
  final int id;
  final String titleEn;
  final String titleAr;
  final Widget iconWidget;
  final VoidCallback? onTap;

  const ServiceItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.iconWidget,
    this.onTap,
  });
}

class StoryItem {
  final int id;
  final String titleEn;
  final String titleAr;
  final Widget iconWidget;

  const StoryItem({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.iconWidget,
  });
}
