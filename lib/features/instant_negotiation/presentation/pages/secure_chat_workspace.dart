import 'package:flutter/material.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/network/rpc_chat_client.dart';

class SecureChatWorkspace extends StatefulWidget {
  final String supplierName;
  final String companyId;

  const SecureChatWorkspace({
    super.key,
    required this.supplierName,
    required this.companyId,
  });

  @override
  State<SecureChatWorkspace> createState() => _SecureChatWorkspaceState();
}

class _SecureChatWorkspaceState extends State<SecureChatWorkspace> {
  final AhmedBabaSocketClient _socketClient = AhmedBabaSocketClient();
  final TextEditingController _msgController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _socketClient.connect(widget.companyId);
    _socketClient.messageStream.listen((msg) {
      setState(() {
        _messages.add(msg);
      });
    });
  }

  @override
  void dispose() {
    _socketClient.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    
    final payload = {
      "type": "text",
      "content": _msgController.text,
      "sender_id": "me",
      "timestamp": DateTime.now().toIso8601String(),
    };

    _socketClient.sendMessage(payload);
    setState(() {
      _messages.add(payload);
    });
    _msgController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplierName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AhmedBabaTokens.primary,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                if (msg['type'] == 'transactional_card') {
                  return _TransactionalCard(
                    data: msg['content'],
                    onApprove: (id) {
                      _socketClient.sendMessage({
                        "type": "contract_approval",
                        "contract_id": id,
                      });
                    },
                  );
                }
                return _MessageBubble(
                  text: msg['content'],
                  isMe: msg['sender_id'] == 'me',
                );
              },
            ),
          ),
          
          // Input Area
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {}),
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: "Enter offer details...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: AhmedBabaTokens.surface,
                      filled: true,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AhmedBabaTokens.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  const _MessageBubble({required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? AhmedBabaTokens.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class _TransactionalCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Function(String) onApprove;

  const _TransactionalCard({required this.data, required this.onApprove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AhmedBabaTokens.secondary, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AhmedBabaTokens.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            color: AhmedBabaTokens.secondary.withOpacity(0.1),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.description, color: AhmedBabaTokens.secondary),
                const SizedBox(width: 8),
                const Text("OFFER: Pro Forma Invoice", style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text("#${data['id']}", style: const TextStyle(fontSize: 10)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _FieldRow(label: "Unit Price", value: "CNY ${data['unit_price']}"),
                _FieldRow(label: "Shipping", value: data['shipping_method']),
                _FieldRow(label: "Volume", value: "${data['volume']} Units"),
                const Divider(),
                _FieldRow(
                  label: "TOTAL CONTRACT", 
                  value: "CNY ${data['total']}", 
                  isValueBold: true,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onApprove(data['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AhmedBabaTokens.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("TAP TO APPROVE CONTRACT"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isValueBold;

  const _FieldRow({required this.label, required this.value, this.isValueBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: isValueBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
