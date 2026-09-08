import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationManager {
  static const String _appId = 'f8c56466-847b-4e5e-955a-4a4ce22fadca';

  static Future<void> initialize() async {
    OneSignal.initialize(_appId);

    // Request permission for iOS (Android grants automatically)
    await OneSignal.Notifications.requestPermission(true);

    // When a notification is tapped, handle navigation
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      if (data != null) {
        _handleNotificationTap(data);
      }
    });
  }

  static void _handleNotificationTap(Map<String, dynamic> data) {
    final type = data['type'];
    // Navigation can be implemented via a global navigator key
    switch (type) {
      case 'ORDER_UPDATE':
        // Navigate to order tracking page
        break;
      case 'RFQ_REPLY':
        // Navigate to RFQ inbox
        break;
      case 'SHIPMENT':
        // Navigate to logistics tracking
        break;
    }
  }

  /// Save user's OneSignal player ID after login
  static Future<void> setUserContext(String userId, String role) async {
    OneSignal.User.addTagWithKey('user_id', userId);
    OneSignal.User.addTagWithKey('role', role); // 'buyer' or 'supplier'
  }
}
