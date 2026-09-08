import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/network/china_box_api_client.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';

class CustomerChatbotPage extends StatefulWidget {
  const CustomerChatbotPage({super.key});

  @override
  State<CustomerChatbotPage> createState() => _CustomerChatbotPageState();
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  _ChatMessage({required this.text, required this.isUser, required this.time});
}

class _CustomerChatbotPageState extends State<CustomerChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;
    _messages.add(
      _ChatMessage(
        text: isAr
            ? 'مرحباً بك في المساعد الذكي لـ A.BABA! كيف يمكنني مساعدتك اليوم بخصوص شحناتك، تتبع الطرود، أو طلبات فوتيان؟'
            : 'Welcome to A.BABA AI Assistant! How can I help you today with your packages, tracking, or Futian orders?',
        isUser: false,
        time: DateTime.now(),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(_ChatMessage(text: cleanText, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollToBottom();

    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;

    try {
      final res = await ChinaBoxApiClient.instance.dio.post('/chatbot/message', data: {
        'message': cleanText,
      });
      final reply = res.data['reply'] ?? (isAr ? 'تم استلام استفسارك وسيتم الرد قريباً' : 'Inquiry received');
      if (mounted) {
        setState(() {
          _messages.add(_ChatMessage(text: reply, isUser: false, time: DateTime.now()));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
            _ChatMessage(
              text: isAr
                  ? 'شكراً لتواصلك. يمكنك متابعة طرودك مباشرة من شاشة "صندوق الصين" أو التحقق من أسعار الشحن. نحن متواجدون لمساعدتك!'
                  : 'Thank you for reaching out. You can track packages in My China Box or check shipping tariffs directly. We are here to help!',
              isUser: false,
              time: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;

    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isAr ? 'مساعد A.BABA الذكي' : 'A.BABA AI Assistant',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Quick action chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildChip(isAr ? '📦 تتبع طرودي' : '📦 Track My Packages', () => _sendMessage(isAr ? 'أين طرودي حالياً؟' : 'Where are my packages?')),
                    const SizedBox(width: 8),
                    _buildChip(isAr ? '🛍️ طلبات فوتيان' : '🛍️ My Futian Orders', () => _sendMessage(isAr ? 'ما هي حالة طلباتي من فوتيان؟' : 'What is my Futian order status?')),
                    const SizedBox(width: 8),
                    _buildChip(isAr ? '✈️ أسعار الشحن' : '✈️ Shipping Rates', () => _sendMessage(isAr ? 'كم سعر الشحن الجوي والبحري؟' : 'What are the shipping rates?')),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: msg.isUser ? const Color(0xFFFF6B00) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                          bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                        ),
                        border: Border.all(color: msg.isUser ? Colors.transparent : const Color(0xFFE2E8F0)),
                        boxShadow: const [
                          BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5,
                          height: 1.4,
                          fontWeight: msg.isUser ? FontWeight.w600 : FontWeight.w500,
                          color: msg.isUser ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isAr ? 'المساعد يكتب الآن...' : 'Assistant is typing...',
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),

            // Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          hintText: isAr ? 'اكتب سؤالك هنا...' : 'Type your question...',
                          hintStyle: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B00),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                        onPressed: () => _sendMessage(_controller.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3EC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFFD4B2)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontFamily: 'Inter', fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFFFF6B00)),
        ),
      ),
    );
  }
}
