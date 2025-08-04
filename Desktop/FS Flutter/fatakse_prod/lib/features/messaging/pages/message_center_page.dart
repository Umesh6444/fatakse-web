import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';
import '../../../shared/models/user_model.dart';
import 'messages_page.dart';

class MessageCenterPage extends StatefulWidget {
  final UserModel user;

  const MessageCenterPage({super.key, required this.user});

  @override
  State<MessageCenterPage> createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends State<MessageCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadConversations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _firestore
          .collection('conversations')
          .where('participants', arrayContains: widget.user.id)
          .orderBy('lastMessageTime', descending: true)
          .get();
      setState(() {
        _conversations = snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _conversations = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Text(
                'All',
                style: AppTextStyles.title.copyWith(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Active',
                style: AppTextStyles.title.copyWith(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'Archived',
                style: AppTextStyles.title.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _startNewConversation,
            icon: const Icon(Icons.edit),
            tooltip: 'New Message',
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConversationsList('all'),
          _buildConversationsList('active'),
          _buildConversationsList('archived'),
        ],
      ),
    );
  }

  Widget _buildConversationsList(String filter) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    List<Map<String, dynamic>> filteredConversations = _conversations;

    if (filter == 'active') {
      filteredConversations = _conversations
          .where(
            (conv) => conv['status'] == 'active' || conv['status'] == 'pending',
          )
          .toList();
    } else if (filter == 'archived') {
      filteredConversations = _conversations
          .where(
            (conv) =>
                conv['status'] == 'completed' || conv['status'] == 'archived',
          )
          .toList();
    }

    if (filteredConversations.isEmpty) {
      return _buildEmptyState(filter);
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: filteredConversations.length,
      itemBuilder: (context, index) {
        final conversation = filteredConversations[index];
        return _buildConversationCard(conversation);
      },
    );
  }

  Widget _buildEmptyState(String filter) {
    String message;
    IconData icon;

    switch (filter) {
      case 'active':
        message = 'No active conversations';
        icon = Icons.chat_bubble_outline;
        break;
      case 'archived':
        message = 'No archived conversations';
        icon = Icons.archive_outlined;
        break;
      default:
        message = 'No conversations yet';
        icon = Icons.message_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64.w, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            message,
            style: AppTextStyles.title.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start a conversation to connect with clients',
            style: AppTextStyles.body.copyWith(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(Map<String, dynamic> conversation) {
    final unreadCount = conversation['unreadCount'] ?? 0;
    final isUnread = unreadCount > 0;
    final lastMessageTime = conversation['lastMessageTime'];

    DateTime timestamp;
    if (lastMessageTime is Timestamp) {
      timestamp = lastMessageTime.toDate();
    } else if (lastMessageTime is DateTime) {
      timestamp = lastMessageTime;
    } else {
      timestamp = DateTime.now();
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.w),
        leading: CircleAvatar(
          radius: 24.w,
          backgroundColor: AppTheme.primaryColor.withAlpha((0.1 * 255).toInt()),
          child: Text(
            conversation['otherUserName']?.substring(0, 1).toUpperCase() ?? 'U',
            style: AppTextStyles.title.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation['otherUserName'] ?? 'Unknown User',
                style: AppTextStyles.title.copyWith(
                  fontSize: 16.sp,
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (isUnread)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$unreadCount',
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              conversation['otherUserRole'] ?? 'User',
              style: AppTextStyles.caption.copyWith(
                fontSize: 12.sp,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              conversation['lastMessage'] ?? '',
              style: AppTextStyles.body.copyWith(
                fontSize: 14.sp,
                color: AppTheme.textSecondary,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTimestamp(timestamp),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                _buildStatusChip(conversation['status'] ?? 'active'),
              ],
            ),
          ],
        ),
        onTap: () => _openConversation(conversation),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String label;

    switch (status) {
      case 'active':
        chipColor = Colors.green;
        label = 'Active';
        break;
      case 'pending':
        chipColor = Colors.orange;
        label = 'Pending';
        break;
      case 'completed':
        chipColor = Colors.blue;
        label = 'Completed';
        break;
      case 'confirmed':
        chipColor = AppTheme.primaryColor;
        label = 'Confirmed';
        break;
      default:
        chipColor = Colors.grey;
        label = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: chipColor.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontSize: 10.sp,
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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

  void _openConversation(Map<String, dynamic> conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          user: widget.user,
          otherUserId: conversation['otherUserId'],
          otherUserName: conversation['otherUserName'],
        ),
      ),
    );
  }

  void _startNewConversation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start New Conversation', style: AppTextStyles.headline),
        content: Text(
          'This feature will allow you to start new conversations with clients and vendors.',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.title),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'New conversation feature will be implemented!',
                    style: AppTextStyles.body,
                  ),
                ),
              );
            },
            child: Text('Coming Soon', style: AppTextStyles.title),
          ),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final UserModel user;
  final String otherUserId;
  final String otherUserName;

  const ChatPage({
    super.key,
    required this.user,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    // Pass user and otherUser map to ChatScreen
    return ChatScreen(
      user: user,
      otherUser: {
        'userId': otherUserId,
        'userName': otherUserName,
        // Add more fields as needed (role, isOnline, etc.)
      },
    );
  }
}
