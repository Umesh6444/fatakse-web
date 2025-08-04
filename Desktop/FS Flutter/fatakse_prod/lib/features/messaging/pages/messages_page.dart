import 'package:flutter/material.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

/// MessagesPage displays the user's conversations and allows messaging with other users.
///
/// Supports filtering, search, and starting new conversations. Integrates with Firestore for real-time chat.
class MessagesPage extends StatefulWidget {
  /// The user whose messages are displayed.
  final UserModel user;

  /// Creates a MessagesPage for the given user.
  const MessagesPage({super.key, required this.user});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

/// State for [MessagesPage]. Handles loading, filtering, and displaying conversations.
class _MessagesPageState extends State<MessagesPage> {
  String _activeRoleFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _conversations = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  /// Loads conversations from Firestore for the current user.
  Future<void> _fetchConversations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final snapshot = await FirebaseFirestore.instance
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
        _error = 'Failed to load conversations: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              showSearchBar();
            },
            icon: Icon(_searchQuery.isEmpty ? Icons.search : Icons.close),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_searchQuery.isNotEmpty ? 56.h : 0),
          child: _searchQuery.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12.w,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                )
              : SizedBox.shrink(),
        ),
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(child: _buildMessagesList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "messages_fab",
        onPressed: _showNewMessageDialog,
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
    // Removed misplaced duplicate Firestore state fields and methods
  }

  /// Toggles the search bar in the app bar.
  void showSearchBar() {
    setState(() {
      if (_searchQuery.isNotEmpty) {
        _searchQuery = '';
        _searchController.clear();
      } else {
        _searchQuery = ' ';
      }
    });
  }

  /// Builds the filter chips for conversation roles.
  Widget _buildFilterTabs() {
    final roles = ['All', 'Clients', 'Artists', 'Vendors'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          for (final role in roles) ...[
            _buildFilterChip(role, _activeRoleFilter == role),
            if (role != roles.last) SizedBox(width: 8.w),
          ],
        ],
      ),
    );
  }

  /// Builds a single filter chip for role selection.
  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _activeRoleFilter = label;
        });
      },
      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  /// Builds the list of conversations, filtered by role and search query.
  Widget _buildMessagesList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: AppTextStyles.caption.copyWith(color: Colors.red),
        ),
      );
    }
    List<Map<String, dynamic>> conversations = _conversations;
    // Filter by role
    if (_activeRoleFilter != 'All') {
      final roleKey = _activeRoleFilter.toLowerCase();
      conversations = conversations.where((c) {
        final userRole = (c['userRole'] as String?)?.toLowerCase() ?? '';
        if (roleKey == 'clients') return userRole.contains('client');
        if (roleKey == 'artists') return userRole.contains('artist');
        if (roleKey == 'vendors') return userRole.contains('vendor');
        return true;
      }).toList();
    }
    // Filter by search
    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      conversations = conversations
          .where(
            (c) =>
                (c['userName'] as String?)?.toLowerCase().contains(query) ==
                    true ||
                (c['lastMessage'] as String?)?.toLowerCase().contains(query) ==
                    true,
          )
          .toList();
    }
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.message, size: 64.sp, color: AppTheme.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'No messages found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try a different search keyword.'
                  : 'Start a conversation to connect with artists or clients',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _buildConversationCard(conversation);
      },
    );
  }

  /// Builds a card for a single conversation in the list.
  Widget _buildConversationCard(Map<String, dynamic> conversation) {
    final isUnread = conversation['unreadCount'] > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12.w),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: AppTheme.getRoleColor(conversation['userRole']),
              child: Text(
                conversation['userName'][0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (conversation['isOnline'])
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation['userName'],
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (isUnread)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${conversation['unreadCount']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
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
              _getRoleDisplayName(conversation['userRole']),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.getRoleColor(conversation['userRole']),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              conversation['lastMessage'],
              style: TextStyle(
                fontSize: 14.sp,
                color: isUnread ? AppTheme.textPrimary : AppTheme.textSecondary,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              conversation['timestamp'],
              style: TextStyle(fontSize: 12.sp, color: AppTheme.textSecondary),
            ),
            if (conversation['bookingId'] != null) ...[
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.infoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Booking',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppTheme.infoColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        onTap: () {
          _openConversation(conversation);
        },
      ),
    );
  }

  /// Opens the chat screen for the selected conversation.
  void _openConversation(Map<String, dynamic> conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatScreen(user: widget.user, otherUser: conversation),
      ),
    );
  }

  /// Shows a dialog to start a new conversation.
  void _showNewMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Conversation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Search for artists, clients, or vendors to start a conversation.',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User search will be implemented next!'),
                ),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  /// Returns the display name for a given user role.
  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'artist':
        return 'Artist';
      case 'household_client':
        return 'Individual Client';
      case 'corporate_client':
        return 'Corporate Client';
      case 'vendor':
        return 'Vendor';
      case 'event_planner':
        return 'Event Planner';
      case 'production_house':
        return 'Production House';
      default:
        return 'User';
    }
  }

  // Removed _getMockConversations; now using Firestore for conversations
}

/// ChatScreen displays a chat conversation between the user and another user.
class ChatScreen extends StatefulWidget {
  /// The current user.
  final UserModel user;

  /// The other user in the conversation.
  final Map<String, dynamic> otherUser;

  /// Creates a ChatScreen for the given users.
  const ChatScreen({super.key, required this.user, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

/// State for [ChatScreen]. Handles message sending, attachments, and UI updates.
class _ChatScreenState extends State<ChatScreen> {
  double? _uploadProgress;
  // For attachment picker
  String? _attachmentPath;
  String? _attachmentType;
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    // Optionally: Load messages from Firestore here if not already handled elsewhere
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Removed _loadMockMessages and mock data. Messages should be loaded from Firestore.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppTheme.getRoleColor(
                widget.otherUser['userRole'],
              ),
              child: Text(
                widget.otherUser['userName'][0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUser['userName'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.otherUser['isOnline']
                        ? 'Online'
                        : 'Last seen recently',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _showVoiceCallDialog,
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: _showVideoCallDialog,
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  void _showVoiceCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Voice Call'),
        content: Text(
          'Would you like to start a voice call with \\${widget.otherUser['userName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateCall('Voice');
            },
            child: Text('Call'),
          ),
        ],
      ),
    );
  }

  void _showVideoCallDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Video Call'),
        content: Text(
          'Would you like to start a video call with \\${widget.otherUser['userName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _simulateCall('Video');
            },
            child: Text('Call'),
          ),
        ],
      ),
    );
  }

  void _simulateCall(String type) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('$type Call in Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              type == 'Voice' ? Icons.call : Icons.videocam,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 16),
            Text('Calling ${widget.otherUser['userName']}...'),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('End Call'),
          ),
        ],
      ),
    );
  }

  /// Builds a chat bubble for a single message.
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.primaryColor : AppTheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isMe ? Radius.circular(16.r) : Radius.circular(4.r),
                bottomRight: isMe
                    ? Radius.circular(4.r)
                    : Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['text'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isMe ? Colors.white : AppTheme.textPrimary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTimestamp(message['timestamp']),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the message input field and attachment picker.
  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_attachmentPath != null) _buildAttachmentPreview(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceVariant,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _pickAttachment,
                      icon: Icon(
                        Icons.attach_file,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                  maxLines: null,
                ),
              ),
              SizedBox(width: 8.w),
              FloatingActionButton.small(
                heroTag: "send_message_fab",
                onPressed: _uploadProgress == null
                    ? () => _sendMessage()
                    : null,
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.send, color: Colors.white, size: 20.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Shows a bottom sheet to pick an attachment type.
  Future<void> _pickAttachment() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Video'),
              onTap: () async {
                Navigator.pop(context);
                await _pickVideo();
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text('File'),
              onTap: () async {
                Navigator.pop(context);
                await _pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Picks an image file for attachment.
  Future<void> _pickImage() async {
    // Use image_picker or file_picker for images
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentPath = result.files.single.path;
        _attachmentType = 'image';
      });
    }
  }

  /// Picks a video file for attachment.
  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentPath = result.files.single.path;
        _attachmentType = 'video';
      });
    }
  }

  /// Picks a generic file for attachment.
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentPath = result.files.single.path;
        _attachmentType = 'file';
      });
    }
  }

  /// Builds a preview widget for the selected attachment.
  Widget _buildAttachmentPreview() {
    IconData icon;
    String label;
    switch (_attachmentType) {
      case 'image':
        icon = Icons.image;
        label = 'Image attached';
        break;
      case 'video':
        icon = Icons.videocam;
        label = 'Video attached';
        break;
      case 'file':
      default:
        icon = Icons.insert_drive_file;
        label = 'File attached';
    }
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          SizedBox(width: 8.w),
          Expanded(child: Text(label)),
          IconButton(
            icon: Icon(Icons.close, color: AppTheme.errorColor),
            onPressed: () {
              setState(() {
                _attachmentPath = null;
                _attachmentType = null;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Sends a message (with optional attachment) to Firestore and updates the UI.
  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _attachmentPath == null) {
      return;
    }

    setState(() {
      _uploadProgress = null;
      // removed _uploadError
    });

    String? attachmentUrl;
    String? attachmentType = _attachmentType;

    // Upload file if present
    if (_attachmentPath != null) {
      try {
        final file = File(_attachmentPath!);
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
        final ref = FirebaseStorage.instance
            .ref()
            .child('chat_attachments')
            .child(widget.user.id)
            .child(fileName);
        final uploadTask = ref.putFile(file);

        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            _uploadProgress =
                event.bytesTransferred /
                (event.totalBytes == 0 ? 1 : event.totalBytes);
          });
        });

        final snapshot = await uploadTask;
        attachmentUrl = await snapshot.ref.getDownloadURL();
      } catch (e) {
        setState(() {
          // removed _uploadError
        });
        return;
      }
    }

    // Prepare message data
    final messageData = {
      'text': _messageController.text.trim(),
      'senderId': widget.user.id,
      'timestamp': FieldValue.serverTimestamp(),
      'isMe': true,
      if (attachmentUrl != null) ...{
        'attachmentUrl': attachmentUrl,
        'attachmentType': attachmentType,
      },
    };

    // Send to Firestore (update collection path as needed)
    await FirebaseFirestore.instance.collection('messages').add(messageData);

    setState(() {
      _messages.add({...messageData, 'timestamp': DateTime.now()});
      _attachmentPath = null;
      _attachmentType = null;
      _uploadProgress = null;
      // removed _uploadError
    });
    _messageController.clear();
  }

  /// Formats a timestamp for display in the chat bubble.
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
