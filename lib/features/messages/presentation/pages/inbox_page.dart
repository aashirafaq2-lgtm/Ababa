import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AhmedBabaTokens.background,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AhmedBabaTokens.textPrimary,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: 4,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => _buildMessageRow(),
      ),
    );
  }

  Widget _buildMessageRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(backgroundColor: Colors.grey[300], radius: 24, child: const Icon(Icons.business, color: Colors.grey)),
              Positioned(right: 0, bottom: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shenzhen Electronics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('10:42 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Yes, we can customize the packaging for your bulk order.', 
                  maxLines: 1, overflow: TextOverflow.ellipsis, 
                  style: TextStyle(color: AhmedBabaTokens.textSecondary)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
