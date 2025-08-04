import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import '../models/community_post_model.dart';

class CommunityPostTile extends StatelessWidget {
  final CommunityPostModel post;
  final dynamic currentUser;
  const CommunityPostTile({super.key, required this.post, this.currentUser});

  bool get canLike => currentUser != null && currentUser.id != post.artistId;
  bool get canShare => true;
  bool get canDelete => currentUser != null && currentUser.id == post.artistId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.artistAvatarUrl != null
                      ? NetworkImage(post.artistAvatarUrl!)
                      : null,
                  child: post.artistAvatarUrl == null
                      ? Text(
                          post.artistName.isNotEmpty ? post.artistName[0] : '?',
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  post.artistName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  _formatTime(post.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (canDelete)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Post'),
                          content: const Text(
                            'Are you sure you want to delete this post?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await FirebaseFirestore.instance
                            .collection('community_posts')
                            .doc(post.id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post deleted')),
                        );
                      }
                    },
                  ),
              ],
            ),
            if (post.caption.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(post.caption),
            ],
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.network(post.imageUrl!, fit: BoxFit.cover),
              ),
            if (post.videoUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => Dialog(
                          insetPadding: const EdgeInsets.all(16),
                          child: _VideoPlayerDialog(url: post.videoUrl!),
                        ),
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: Colors.black12),
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: post.likedBy.contains(currentUser?.id)
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: canLike
                      ? () async {
                          final doc = FirebaseFirestore.instance
                              .collection('community_posts')
                              .doc(post.id);
                          final isLiked = post.likedBy.contains(currentUser.id);
                          await doc.update({
                            'likedBy': isLiked
                                ? FieldValue.arrayRemove([currentUser.id])
                                : FieldValue.arrayUnion([currentUser.id]),
                            'likeCount': isLiked
                                ? post.likeCount - 1
                                : post.likeCount + 1,
                          });
                        }
                      : null,
                ),
                Text('${post.likeCount}'),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: canShare
                      ? () async {
                          final postUrl = post.shareUrl;
                          if (postUrl.isNotEmpty) {
                            try {
                              await Share.share(
                                postUrl,
                                subject: 'Check out this post on Fatakse!',
                              );
                            } catch (e) {
                              // Fallback: copy to clipboard
                              await Clipboard.setData(
                                ClipboardData(text: postUrl),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Link copied to clipboard!'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No shareable link available.'),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _VideoPlayerDialog extends StatefulWidget {
  final String url;
  const _VideoPlayerDialog({required this.url});

  @override
  State<_VideoPlayerDialog> createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<_VideoPlayerDialog> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          _controller.value.isInitialized && _controller.value.aspectRatio > 0
          ? _controller.value.aspectRatio
          : 9 / 16,
      child: _initialized
          ? Stack(
              children: [
                VideoPlayer(_controller),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
