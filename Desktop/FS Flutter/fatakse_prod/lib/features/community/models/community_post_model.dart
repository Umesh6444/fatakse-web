import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CommunityPostModel extends Equatable {
  final String id;
  final String artistId;
  final String artistName;
  final String? artistAvatarUrl;
  final String? imageUrl;
  final String? videoUrl;
  final String caption;
  final DateTime createdAt;
  final int likeCount;
  final List<String> likedBy;

  /// Computed property for shareable post URL
  String get shareUrl => 'https://fatakse.com/community/post/$id';

  const CommunityPostModel({
    required this.id,
    required this.artistId,
    required this.artistName,
    this.artistAvatarUrl,
    this.imageUrl,
    this.videoUrl,
    required this.caption,
    required this.createdAt,
    this.likeCount = 0,
    this.likedBy = const [],
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] ?? '',
      artistId: json['artistId'] ?? '',
      artistName: json['artistName'] ?? '',
      artistAvatarUrl: json['artistAvatarUrl'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      caption: json['caption'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likeCount: json['likeCount'] ?? 0,
      likedBy: List<String>.from(json['likedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'artistId': artistId,
    'artistName': artistName,
    'artistAvatarUrl': artistAvatarUrl,
    'imageUrl': imageUrl,
    'videoUrl': videoUrl,
    'caption': caption,
    'createdAt': Timestamp.fromDate(createdAt),
    'likeCount': likeCount,
    'likedBy': likedBy,
  };

  @override
  List<Object?> get props => [
    id,
    artistId,
    artistName,
    imageUrl,
    videoUrl,
    caption,
    createdAt,
    likeCount,
    likedBy,
  ];
}
