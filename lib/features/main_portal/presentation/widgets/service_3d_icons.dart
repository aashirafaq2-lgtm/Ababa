import 'package:flutter/material.dart';

/// Renders the 3D service icons extracted directly from the reference design.
/// Each icon asset (service_1.png through service_10.png) was extracted from
/// the user's exact reference screenshots at native pixel fidelity.
class Service3DIcon extends StatelessWidget {
  final int id;

  /// Display size of the icon inside the card.
  /// Default 48px — scaled to fill the icon area of each 5-column card tile.
  final double size;

  const Service3DIcon({super.key, required this.id, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/services/service_$id.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.category_rounded,
        size: size * 0.8,
        color: const Color(0xFFFF8C00),
      ),
    );
  }
}
