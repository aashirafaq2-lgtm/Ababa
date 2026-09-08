import 'package:flutter/material.dart';

/// Displays the official A.BABA / Alibaba brand logo from the original project asset.
/// Uses assets/branding/logo.png — the real, original brand asset.
/// The [size] parameter controls the rendered width/height.
class ABabaMonogram extends StatelessWidget {
  final double size;

  const ABabaMonogram({super.key, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/branding/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
