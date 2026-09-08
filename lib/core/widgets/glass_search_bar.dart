import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class GlassSearchBar extends StatelessWidget {
  const GlassSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Colors.black54, size: 20),
              const SizedBox(width: 10),
              const Expanded(child: Text('Search global machinery...', style: TextStyle(color: Colors.black45, fontSize: 13))),
              Icon(Icons.camera_alt_outlined, color: Colors.black54, size: 20),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
