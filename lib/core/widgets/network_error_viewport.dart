import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class NetworkErrorViewport extends StatelessWidget {
  final VoidCallback onRetry;
  const NetworkErrorViewport({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          const Text('Connection Failed', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.black87)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Please check your internet connection or global proxy settings and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 160,
            height: 48,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AhmedBabaTokens.primary,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: const Text('Try Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
