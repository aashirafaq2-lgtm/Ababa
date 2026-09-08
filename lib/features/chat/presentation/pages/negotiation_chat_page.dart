import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';

class NegotiationChatPage extends StatefulWidget {
  final String supplierName;
  const NegotiationChatPage({super.key, required this.supplierName});

  @override
  State<NegotiationChatPage> createState() => _NegotiationChatPageState();
}

class _NegotiationChatPageState extends State<NegotiationChatPage> {
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'supplier', 'text': 'Hello Ahmad! I saw your inquiry for the 6061 Aluminum parts.', 'time': '10:00 AM'},
    {'sender': 'supplier', 'text': 'Are you looking for the anodized version or the natural finish?', 'time': '10:01 AM'},
    {'sender': 'user', 'text': 'Hi! I need the anodized blue finish. Final quantity will be around 10,000 pieces.', 'time': '10:05 AM'},
    {'sender': 'supplier', 'text': 'Okay, for 10k pieces I can offer you \$4.45 per piece. FOB Shenzhen.', 'time': '10:07 AM'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(radius: 16, backgroundColor: Colors.grey[200], child: const Icon(Icons.business, size: 18, color: Colors.grey)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.supplierName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Text('Online • Verified Supplier', style: TextStyle(fontSize: 10, color: Colors.green)),
              ],
            )
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call_outlined), onPressed: () {}),
        ],
        elevation: 0.5,
      ),
      body: Column(
        children: [
          _buildItemContextBanner(),
          Expanded(child: _buildChatList()),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildItemContextBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 12),
          const Expanded(child: Text('Custom CNC Machining Parts...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          TextButton(onPressed: () {}, child: const Text('Send Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (ctx, i) {
        final m = _messages[i];
        final isUser = m['sender'] == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                decoration: BoxDecoration(
                  color: isUser ? AhmedBabaTokens.primary : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 1))],
                ),
                child: Text(
                  m['text'],
                  style: TextStyle(color: isUser ? Colors.white : Colors.black87, fontSize: 13, height: 1.4),
                ),
              ),
              Text(m['time'], style: const TextStyle(fontSize: 9, color: Colors.grey)),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.grey), onPressed: () {}),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(20)),
              child: const TextField(
                decoration: InputDecoration(hintText: 'Type your message...', border: InputBorder.none, hintStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),
          IconButton(icon: Icon(Icons.send, color: AhmedBabaTokens.primary), onPressed: () {}),
        ],
      ),
    );
  }
}
