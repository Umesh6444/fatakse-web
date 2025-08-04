import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../../shared/models/user_model.dart';
import '../models/community_post_model.dart';
import '../widgets/community_post_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fatakse_prod/config/app_text_styles.dart';

/// CommunityFeedPage displays the community feed with posts from all users.
///
/// Integrates with Firestore for real-time post updates and allows artists to create posts.
class CommunityFeedPage extends StatelessWidget {
  /// Creates a CommunityFeedPage.
  const CommunityFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state is AuthAuthenticated
        ? (context.read<AuthBloc>().state as AuthAuthenticated).user
        : null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Feed', style: AppTextStyles.headline),
        actions: [
          if (user != null && user.role == 'artist')
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              tooltip: 'Create Post',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommunityCreatePostPage(user: user),
                  ),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('community_posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No posts yet.', style: AppTextStyles.body),
            );
          }
          final posts = snapshot.data!.docs
              .map(
                (doc) => CommunityPostModel.fromJson({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }),
              )
              .toList();
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return CommunityPostTile(post: posts[index], currentUser: user);
            },
          );
        },
      ),
    );
  }
}

/// CommunityCreatePostPage allows artists to create and upload new community posts.
class CommunityCreatePostPage extends StatefulWidget {
  /// The user creating the post.
  final UserModel user;

  /// Creates a CommunityCreatePostPage for the given user.
  const CommunityCreatePostPage({super.key, required this.user});

  @override
  State<CommunityCreatePostPage> createState() =>
      _CommunityCreatePostPageState();
}

/// State for [CommunityCreatePostPage]. Handles media picking, post creation, and UI updates.
class _CommunityCreatePostPageState extends State<CommunityCreatePostPage> {
  final _captionController = TextEditingController();
  XFile? _mediaFile;
  bool _isVideo = false;
  bool _loading = false;

  /// Shows a bottom sheet to pick an image or video for the post.
  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    final media = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: Text('Pick Image', style: AppTextStyles.body),
              onTap: () async {
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );
                Navigator.pop(ctx, picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text('Pick Video (max 30s)', style: AppTextStyles.body),
              onTap: () async {
                final picked = await picker.pickVideo(
                  source: ImageSource.gallery,
                  maxDuration: const Duration(seconds: 30),
                );
                Navigator.pop(ctx, picked);
              },
            ),
          ],
        ),
      ),
    );
    if (media != null) {
      setState(() {
        _mediaFile = media;
        _isVideo =
            media.path.endsWith('.mp4') ||
            media.path.endsWith('.mov') ||
            media.mimeType?.startsWith('video') == true;
      });
    }
  }

  /// Submits the new post to Firestore and uploads media to Firebase Storage.
  Future<void> _submitPost() async {
    if (_captionController.text.trim().isEmpty && _mediaFile == null) return;
    setState(() => _loading = true);
    String? imageUrl;
    String? videoUrl;
    try {
      if (_mediaFile != null) {
        final ext = _mediaFile!.path.split('.').last;
        final ref = FirebaseStorage.instance.ref().child(
          'community_posts/${widget.user.id}_${DateTime.now().millisecondsSinceEpoch}.$ext',
        );
        final uploadTask = ref.putData(await _mediaFile!.readAsBytes());
        final snap = await uploadTask;
        final url = await snap.ref.getDownloadURL();
        if (_isVideo) {
          videoUrl = url;
        } else {
          imageUrl = url;
        }
      }
      final post = CommunityPostModel(
        id: '',
        artistId: widget.user.id,
        artistName: '${widget.user.firstName} ${widget.user.lastName}',
        artistAvatarUrl: widget.user.profileImageUrl,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
        caption: _captionController.text.trim(),
        createdAt: DateTime.now(),
        likeCount: 0,
        likedBy: [],
      );
      final doc = await FirebaseFirestore.instance
          .collection('community_posts')
          .add(post.toJson());
      await doc.update({'id': doc.id});
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to post: $e',
            style: AppTextStyles.caption.copyWith(color: Colors.red),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post', style: AppTextStyles.headline)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(labelText: 'Caption'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            if (_mediaFile != null)
              _isVideo
                  ? Container(
                      height: 200,
                      color: Colors.black12,
                      child: const Center(
                        child: Icon(Icons.videocam, size: 48),
                      ),
                    )
                  : FutureBuilder<Uint8List>(
                      future: _mediaFile!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: Icon(Icons.broken_image)),
                          );
                        }
                        return Image.memory(
                          snapshot.data!,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickMedia,
                  icon: const Icon(Icons.attach_file),
                  label: Text('Add Image/Video', style: AppTextStyles.body),
                ),
                const SizedBox(width: 16),
                if (_mediaFile != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _mediaFile = null),
                  ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitPost,
                child: _loading
                    ? const CircularProgressIndicator()
                    : Text('Post', style: AppTextStyles.title),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
