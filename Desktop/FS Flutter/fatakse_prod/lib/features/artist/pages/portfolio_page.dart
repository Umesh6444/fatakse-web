import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';

/// PortfolioPage allows artists to showcase their best work to attract clients.
///
/// Integrates with Firestore and Firebase Storage for portfolio management.
class PortfolioPage extends StatefulWidget {
  /// Creates a PortfolioPage.
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

/// State for [PortfolioPage]. Handles loading, adding, and deleting portfolio items.
class _PortfolioPageState extends State<PortfolioPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  List<Map<String, dynamic>> _portfolioItems = [];

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  /// Loads the user's portfolio items from Firestore.
  Future<void> _loadPortfolio() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('portfolios')
            .where('userId', isEqualTo: user.uid)
            .get();

        final items = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();

        // Sort by createdAt in Dart since Firestore orderBy might not be indexed
        items.sort((a, b) {
          final aTime = a['createdAt'] as Timestamp?;
          final bTime = b['createdAt'] as Timestamp?;
          if (aTime == null || bTime == null) return 0;
          return bTime.compareTo(aTime); // Descending order
        });

        setState(() {
          _portfolioItems = items;
        });
      }
    } catch (e) {
      debugPrint('Portfolio Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading portfolio: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog to add a new portfolio item.
  Future<void> _addPortfolioItem() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _PortfolioDialog(),
    );

    if (result != null) {
      await _savePortfolioItem(result);
    }
  }

  /// Saves a new portfolio item to Firestore and uploads its image to Firebase Storage.
  Future<void> _savePortfolioItem(Map<String, dynamic> item) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        String? imageUrl;
        // Pick image file
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null && result.files.single.path != null) {
          final file = File(result.files.single.path!);
          final fileName =
              '${user.uid}_${DateTime.now().millisecondsSinceEpoch}_${file.uri.pathSegments.last}';
          final ref = FirebaseStorage.instance
              .ref()
              .child('portfolio_images')
              .child(user.uid)
              .child(fileName);
          final uploadTask = ref.putFile(file);
          final snapshot = await uploadTask;
          imageUrl = await snapshot.ref.getDownloadURL();
        }
        await _firestore.collection('portfolios').add({
          'userId': user.uid,
          'title': item['title'],
          'description': item['description'],
          'category': item['category'],
          'imageUrl': imageUrl ?? 'https://via.placeholder.com/300x200',
          'createdAt': Timestamp.now(),
        });

        await _loadPortfolio();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Portfolio item added successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving portfolio item: $e')),
      );
    }
  }

  /// Deletes a portfolio item from Firestore.
  Future<void> _deletePortfolioItem(String itemId) async {
    try {
      await _firestore.collection('portfolios').doc(itemId).delete();
      await _loadPortfolio();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Portfolio item deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting portfolio item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Portfolio',
          style: AppTextStyles.headline.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.artistColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    'Showcase your best work to attract more clients',
                    style: AppTextStyles.title.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: _portfolioItems.isEmpty
                      ? _buildEmptyState()
                      : _buildPortfolioGrid(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: "portfolio_fab",
        onPressed: _addPortfolioItem,
        backgroundColor: AppTheme.artistColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Builds the empty state widget when no portfolio items exist.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library, size: 64.sp, color: AppTheme.textSecondary),
          SizedBox(height: 16.h),
          Text(
            'No portfolio items yet',
            style: AppTextStyles.title.copyWith(color: AppTheme.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your best work to showcase your talents',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Builds the grid view of portfolio items.
  Widget _buildPortfolioGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.75,
      ),
      itemCount: _portfolioItems.length,
      itemBuilder: (context, index) {
        final item = _portfolioItems[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  color: AppTheme.artistColor.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.image,
                    size: 48.sp,
                    color: AppTheme.artistColor,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] ?? '',
                        style: AppTextStyles.title.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item['category'] ?? '',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: AppTheme.errorColor,
                              size: 18.sp,
                            ),
                            onPressed: () => _deletePortfolioItem(item['id']),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Dialog for adding a new portfolio item.
class _PortfolioDialog extends StatefulWidget {
  @override
  _PortfolioDialogState createState() => _PortfolioDialogState();
}

/// State for [_PortfolioDialog]. Handles form input for portfolio item details.
class _PortfolioDialogState extends State<_PortfolioDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Performance';

  final List<String> _categories = [
    'Performance',
    'Music',
    'Dance',
    'Theater',
    'Photography',
    'Art',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Portfolio Item', style: AppTextStyles.headline),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter title for your work',
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your work',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category, style: AppTextStyles.body),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppTextStyles.title),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descriptionController.text,
                'category': _selectedCategory,
              });
            }
          },
          child: Text('Add', style: AppTextStyles.title),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
