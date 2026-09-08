import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/network/china_box_api_client.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    setState(() => _isLoading = true);
    try {
      final res = await ChinaBoxApiClient.instance.dio.get('/notifications');
      if (mounted) {
        setState(() {
          _notifications = res.data['notifications'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    final loc = ChinaBoxLocalization();
    final isAr = loc.isRtl;
    try {
      await ChinaBoxApiClient.instance.dio.patch('/notifications/read-all');
      setState(() {
        for (var n in _notifications) {
          n['isRead'] = true;
          n['is_read'] = true;
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAr ? 'تم تعيين جميع الإشعارات كمقروءة' : 'All marked as read'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _markSingleRead(String id, int index) async {
    try {
      await ChinaBoxApiClient.instance.dio.patch('/notifications/$id/read');
      setState(() {
        _notifications[index]['isRead'] = true;
        _notifications[index]['is_read'] = true;
      });
    } catch (_) {}
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
          title: Text(
            isAr ? 'مركز الإشعارات' : 'Notification Center',
            style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          actions: [
            if (_notifications.isNotEmpty)
              TextButton(
                onPressed: _markAllRead,
                child: Text(
                  isAr ? 'قراءة الكل' : 'Mark all read',
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFFF6B00)),
                ),
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B00)))
            : _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.notifications_none_rounded, size: 40, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isAr ? 'لا توجد إشعارات حالياً' : 'No notifications yet',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF334155)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isAr ? 'ستصلك هنا تحديثات شحناتك والطلبات فور حدوثها' : 'Your package and order updates will appear here',
                          style: const TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchNotifications,
                    color: const Color(0xFFFF6B00),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: _notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final n = _notifications[i];
                        final isRead = n['isRead'] == true || n['is_read'] == true;
                        final title = n['title'] ?? '';
                        final message = n['message'] ?? '';
                        final createdAt = n['createdAt'] ?? n['created_at'] ?? '';
                        final id = n['id'] ?? '';

                        return GestureDetector(
                          onTap: () {
                            if (!isRead && id.isNotEmpty) {
                              _markSingleRead(id, i);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.white : const Color(0xFFFFFBF7),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isRead ? const Color(0xFFE2E8F0) : const Color(0xFFFFD4B2),
                                width: isRead ? 1 : 1.5,
                              ),
                              boxShadow: const [
                                BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: isRead ? const Color(0xFFF1F5F9) : const Color(0xFFFFF3EC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.local_shipping_rounded,
                                      size: 20,
                                      color: isRead ? const Color(0xFF64748B) : const Color(0xFFFF6B00),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13.5,
                                                fontWeight: isRead ? FontWeight.w700 : FontWeight.w900,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                          if (!isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFF6B00),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        message,
                                        style: const TextStyle(fontFamily: 'Inter', fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                                      ),
                                      if (createdAt.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          createdAt.toString().split('T').first,
                                          style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF94A3B8)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
