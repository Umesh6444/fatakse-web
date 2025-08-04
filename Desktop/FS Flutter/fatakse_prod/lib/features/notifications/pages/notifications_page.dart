import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/app_text_styles.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

/// NotificationsPage displays user notifications and allows marking them as read.
///
/// Integrates with Firestore for real-time notification updates.
class NotificationsPage extends StatefulWidget {
  /// The user whose notifications are displayed.
  final UserModel user;

  /// Creates a NotificationsPage for the given user.
  const NotificationsPage({super.key, required this.user});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

/// State for [NotificationsPage]. Handles loading, displaying, and updating notifications.
class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  /// Loads notifications from Firestore for the current user.
  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: widget.user.id)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      setState(() {
        _notifications = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      setState(() {
        _notifications = [];
        _isLoading = false;
      });
    }
  }

  /// Marks a single notification as read in Firestore and updates the UI.
  Future<void> _markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });

      setState(() {
        final index = _notifications.indexWhere(
          (n) => n['id'] == notificationId,
        );
        if (index != -1) {
          _notifications[index]['isRead'] = true;
        }
      });
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Notifications', style: AppTextStyles.headline),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
    );
  }

  /// Builds the empty state widget when there are no notifications.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64.w, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: AppTextStyles.title.copyWith(color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          Text(
            'Check back later for updates',
            style: AppTextStyles.body.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  /// Builds a card for a single notification.
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] ?? false;
    final type = notification['type'] ?? 'general';
    final createdAt = notification['createdAt'];

    DateTime timestamp;
    if (createdAt is Timestamp) {
      timestamp = createdAt.toDate();
    } else if (createdAt is DateTime) {
      timestamp = createdAt;
    } else {
      timestamp = DateTime.now();
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: isRead
          ? Colors.white
          : AppTheme.primaryColor.withAlpha((0.05 * 255).toInt()),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(type),
          child: Icon(
            _getNotificationIcon(type),
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        title: Text(
          notification['title'] ?? 'Notification',
          style: AppTextStyles.title.copyWith(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              notification['message'] ?? '',
              style: AppTextStyles.body.copyWith(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 8.h),
            Text(
              _formatTimestamp(timestamp),
              style: AppTextStyles.caption.copyWith(
                color: AppTheme.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          if (!isRead) {
            _markAsRead(notification['id']);
          }
          _handleNotificationTap(notification);
        },
      ),
    );
  }

  /// Returns the color for a notification type.
  Color _getNotificationColor(String type) {
    switch (type) {
      case 'booking_request':
        return Colors.blue;
      case 'payment_received':
        return Colors.green;
      case 'booking_confirmed':
        return AppTheme.primaryColor;
      case 'profile_view':
        return Colors.orange;
      case 'review_received':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Returns the icon for a notification type.
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'booking_request':
        return Icons.event;
      case 'payment_received':
        return Icons.payment;
      case 'booking_confirmed':
        return Icons.check_circle;
      case 'profile_view':
        return Icons.visibility;
      case 'review_received':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  /// Formats a timestamp for display in the notification card.
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Handles tap actions for different notification types.
  void _handleNotificationTap(Map<String, dynamic> notification) {
    final type = notification['type'];

    switch (type) {
      case 'booking_request':
      case 'booking_confirmed':
        // Navigate to bookings page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening booking details...',
              style: AppTextStyles.caption,
            ),
          ),
        );
        break;
      case 'payment_received':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Opening payment details...',
              style: AppTextStyles.caption,
            ),
          ),
        );
        break;
      case 'review_received':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening reviews...', style: AppTextStyles.caption),
          ),
        );
        break;
      default:
        break;
    }
  }

  /// Marks all notifications as read in Firestore and updates the UI.
  Future<void> _markAllAsRead() async {
    try {
      final batch = _firestore.batch();

      for (final notification in _notifications) {
        if (!(notification['isRead'] ?? false)) {
          final docRef = _firestore
              .collection('notifications')
              .doc(notification['id']);
          batch.update(docRef, {'isRead': true});
        }
      }

      await batch.commit();

      setState(() {
        for (int i = 0; i < _notifications.length; i++) {
          _notifications[i]['isRead'] = true;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All notifications marked as read',
            style: AppTextStyles.caption,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to mark all as read',
            style: AppTextStyles.caption.copyWith(color: Colors.red),
          ),
        ),
      );
    }
  }
}
