import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class ChatTranslationBar extends StatelessWidget {
  const ChatTranslationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        border: Border(bottom: BorderSide(color: Colors.blue.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          const Icon(Icons.g_translate_rounded, color: Colors.blue, size: 16),
          const SizedBox(width: 8),
          const Expanded(child: Text('Click to translate messages (Chinese ↔ Urdu)', style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold))),
          Switch.adaptive(value: true, onChanged: (v) {}, activeColor: Colors.blue),
        ],
      ),
    );
  }
}
