import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class AhmedBabaSocketClient {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController = StreamController.broadcast();
  
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectLimit = 5;

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  Future<void> connect(String companyId) async {
    if (_isConnecting) return;
    _isConnecting = true;

    final url = 'wss://api.ahmedbaba.com/negotiation?company_id=$companyId';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      _channel!.stream.listen(
        (data) {
          _reconnectAttempts = 0;
          final Map<String, dynamic> decoded = jsonDecode(data);
          _messageController.add(decoded);
        },
        onError: (error) {
          _handleReconnect(companyId);
        },
        onDone: () {
          _handleReconnect(companyId);
        },
      );
    } catch (e) {
      _handleReconnect(companyId);
    } finally {
      _isConnecting = false;
    }
  }

  void _handleReconnect(String companyId) {
    if (_reconnectAttempts < _maxReconnectLimit) {
      _reconnectAttempts++;
      final delay = Duration(seconds: 2 * _reconnectAttempts); // Exponential backoff
      Timer(delay, () => connect(companyId));
    }
  }

  void sendMessage(Map<String, dynamic> payload) {
    if (_channel != null) {
      _channel!.sink.add(jsonEncode(payload));
    }
  }

  void disconnect() {
    _channel?.sink.close(status.goingAway);
    _reconnectAttempts = _maxReconnectLimit; // Block automated reconnect
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}
