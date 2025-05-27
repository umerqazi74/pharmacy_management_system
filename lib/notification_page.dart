import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'N001',
      title: 'Inventory Low Stock',
      message: 'Paracetamol 500mg stock is below minimum level',
      date: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      type: NotificationType.warning,
    ),
    NotificationItem(
      id: 'N002',
      title: 'New Order Received',
      message: 'Order #ORD-2023-4567 from Regular Customer',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      type: NotificationType.order,
    ),
    NotificationItem(
      id: 'N003',
      title: 'Payment Received',
      message: 'Payment of \$245.50 for Invoice #INV-2023-7890',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: NotificationType.payment,
    ),
    NotificationItem(
      id: 'N004',
      title: 'System Update Available',
      message: 'New version v2.1.0 is ready to install',
      date: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
      type: NotificationType.system,
    ),
    NotificationItem(
      id: 'N005',
      title: 'Expiry Alert',
      message: 'Amoxicillin 500mg capsules expiring in 15 days',
      date: DateTime.now().subtract(const Duration(days: 5)),
      isRead: false,
      type: NotificationType.alert,
    ),
  ];

  bool _showOnlyUnread = false;
  NotificationFilter _currentFilter = NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = _notifications.where((notification) {
      final matchesUnread = !_showOnlyUnread || !notification.isRead;
      final matchesFilter = _currentFilter == NotificationFilter.all ||
          notification.type == _typeFromFilter(_currentFilter);
      return matchesUnread && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(_showOnlyUnread ? Icons.mark_email_read : Icons.mark_email_unread),
            onPressed: () => setState(() => _showOnlyUnread = !_showOnlyUnread),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Chip(
                  label: Text('${filteredNotifications.length} items'),
                  backgroundColor: Colors.blue[50],
                ),
                const Spacer(),
                Text(
                  _currentFilter == NotificationFilter.all
                      ? 'All Notifications'
                      : '${_currentFilter.toString().split('.').last} Only',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredNotifications.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = filteredNotifications[index];
                return _buildNotificationCard(notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      color: notification.isRead ? Colors.grey[50] : Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _viewNotification(notification),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(notification.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notification.isRead
                                  ? Colors.grey[700]
                                  : Colors.blue[800],
                            ),
                          ),
                        ),
                        Text(
                          DateFormat('h:mm a').format(notification.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM d, y').format(notification.date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        if (!notification.isRead)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child:  Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.order:
        icon = Icons.shopping_cart;
        color = Colors.green;
        break;
      case NotificationType.payment:
        icon = Icons.attach_money;
        color = Colors.teal;
        break;
      case NotificationType.warning:
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case NotificationType.alert:
        icon = Icons.notification_important;
        color = Colors.red;
        break;
      case NotificationType.system:
        icon = Icons.system_update;
        color = Colors.purple;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  void _viewNotification(NotificationItem notification) {
    if (!notification.isRead) {
      setState(() {
        _notifications.firstWhere((n) => n.id == notification.id).isRead = true;
      });
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification.message,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                DateFormat('MMM d, y - h:mm a').format(notification.date),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(
                  notification.type.toString().split('.').last,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: _getNotificationColor(notification.type).withOpacity(0.1),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!notification.isRead)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _markAsRead(notification.id);
              },
              child: const Text('Mark as Read'),
            ),
        ],
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      _notifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: NotificationFilter.values.map((filter) {
              return RadioListTile<NotificationFilter>(
                title: Text(filter.toString().split('.').last),
                value: filter,
                groupValue: _currentFilter,
                onChanged: (value) {
                  setState(() => _currentFilter = value!);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.order: return Colors.green;
      case NotificationType.payment: return Colors.teal;
      case NotificationType.warning: return Colors.orange;
      case NotificationType.alert: return Colors.red;
      case NotificationType.system: return Colors.purple;
      default: return Colors.blue;
    }
  }

  NotificationType _typeFromFilter(NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.orders: return NotificationType.order;
      case NotificationFilter.payments: return NotificationType.payment;
      case NotificationFilter.warnings: return NotificationType.warning;
      case NotificationFilter.alerts: return NotificationType.alert;
      case NotificationFilter.system: return NotificationType.system;
      default: return NotificationType.order;
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  bool isRead;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.isRead,
    required this.type,
  });
}

enum NotificationType {
  order,
  payment,
  warning,
  alert,
  system,
}

enum NotificationFilter {
  all,
  orders,
  payments,
  warnings,
  alerts,
  system,
}