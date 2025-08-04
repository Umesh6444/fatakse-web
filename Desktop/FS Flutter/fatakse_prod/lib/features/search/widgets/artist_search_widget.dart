import '../../bookings/pages/booking_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/theme/app_theme.dart';
import '../../artist/pages/profile_page.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user_model.dart';

class ArtistSearchWidget extends StatefulWidget {
  final UserModel user;
  final FirebaseFirestore firestore;

  ArtistSearchWidget({
    super.key,
    required this.user,
    FirebaseFirestore? firestore,
  }) : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  State<ArtistSearchWidget> createState() => _ArtistSearchWidgetState();
}

class _ArtistSearchWidgetState extends State<ArtistSearchWidget> {
  late final FirebaseFirestore _firestore;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All Locations';
  double _maxBudget = 50000;
  bool _isFilterExpanded = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _artists = [];

  @override
  @override
  void initState() {
    super.initState();
    _firestore = widget.firestore;
    _loadArtists();
  }

  Future<void> _loadArtists() async {
    setState(() => _isLoading = true);

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'artist')
          .where('isActive', isEqualTo: true)
          .get();

      final artists = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',
          'category': (data['categories'] as List?)?.isNotEmpty == true
              ? data['categories'][0]
              : 'Performer',
          'location': data['location'] ?? 'India',
          'rating':
              4.5 + (doc.id.hashCode % 10) / 20, // Generate rating 4.5-5.0
          'reviews': 20 + (doc.id.hashCode % 50), // Generate 20-70 reviews
          'price': _generatePrice(data['categories'] as List?),
          'availability': 'Available',
          'email': data['email'],
          'bio': data['bio'],
        };
      }).toList();

      setState(() {
        _artists = artists;
      });
    } catch (e) {
      debugPrint('Artists loading error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading artists: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _generatePrice(List? categories) {
    final basePrice = categories?.isNotEmpty == true
        ? _getCategoryBasePrice(categories![0])
        : 15000;
    final variation = (basePrice * 0.3); // ±30% variation
    final price =
        basePrice + (categories.hashCode % variation.toInt()) - (variation / 2);
    return price.toInt().toString();
  }

  int _getCategoryBasePrice(String category) {
    switch (category.toLowerCase()) {
      case 'singer':
        return 25000;
      case 'dancer':
        return 20000;
      case 'dj':
        return 30000;
      case 'band':
        return 40000;
      case 'musician':
        return 22000;
      case 'comedian':
        return 15000;
      case 'magician':
        return 18000;
      default:
        return 20000;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Header
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.clientColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search artists, bands, DJs...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isFilterExpanded
                            ? Icons.filter_list_off
                            : Icons.filter_list,
                        color: AppTheme.clientColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isFilterExpanded = !_isFilterExpanded;
                        });
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  onChanged: (value) {
                    // Real-time search
                    setState(() {});
                  },
                ),
              ),

              // Filters (Expandable)
              if (_isFilterExpanded) ...[
                SizedBox(height: 16.h),
                _buildFiltersSection(),
              ],
            ],
          ),
        ),

        // Quick Categories
        _buildQuickCategories(),

        // Artists List
        Expanded(child: _buildArtistsList()),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            value: _selectedLocation,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
            items:
                [
                      'All Locations',
                      'Mumbai',
                      'Delhi',
                      'Bangalore',
                      'Chennai',
                      'Kolkata',
                      'Hyderabad',
                      'Pune',
                      'Ahmedabad',
                      'Jaipur',
                      'Lucknow',
                    ]
                    .map(
                      (location) => DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLocation = value!;
              });
            },
          ),
          SizedBox(height: 16.h),
          Text(
            'Max Budget: 9${_maxBudget.toInt()}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          Slider(
            value: _maxBudget,
            min: 5000,
            max: 100000,
            divisions: 19,
            activeColor: AppTheme.clientColor,
            onChanged: (value) {
              setState(() {
                _maxBudget = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCategories() {
    final quickCategories = [
      'Singer',
      'Dancer',
      'DJ',
      'Band',
      'Comedian',
      'Magician',
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'Popular Categories',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: quickCategories.length,
              itemBuilder: (context, index) {
                final category = quickCategories[index];
                final isSelected = _selectedCategory == category;

                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                    selectedColor: AppTheme.clientColor.withValues(alpha: 0.2),
                    checkmarkColor: AppTheme.clientColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppTheme.clientColor
                          : AppTheme.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_artists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.sp, color: AppTheme.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'No artists found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    // Filter artists based on search criteria
    final filteredArtists = _artists.where((artist) {
      // Search filter
      final searchQuery = _searchController.text.toLowerCase();
      final nameMatch = artist['name'].toLowerCase().contains(searchQuery);
      final categoryMatch = artist['category'].toLowerCase().contains(
        searchQuery,
      );

      // Category filter
      final categoryFilter =
          _selectedCategory == 'All' ||
          artist['category'].toLowerCase().contains(
            _selectedCategory.toLowerCase(),
          );

      // Location filter
      final locationFilter =
          _selectedLocation == 'All Locations' ||
          artist['location'].toLowerCase().contains(
            _selectedLocation.toLowerCase(),
          );

      // Budget filter
      final artistPrice = double.tryParse(artist['price']) ?? 0;
      final budgetFilter = artistPrice <= _maxBudget;

      return (nameMatch || categoryMatch) &&
          categoryFilter &&
          locationFilter &&
          budgetFilter;
    }).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: filteredArtists.length,
      itemBuilder: (context, index) {
        final artist = filteredArtists[index];
        return _buildArtistCard(artist);
      },
    );
  }

  Widget _buildArtistCard(Map<String, dynamic> artist) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Artist Image and Basic Info
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppTheme.clientColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40.sp,
                    color: AppTheme.clientColor,
                  ),
                ),

                SizedBox(width: 16.w),

                // Artist Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artist['name'],
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        artist['category'],
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.clientColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14.sp,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            artist['location'],
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          // Rating
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: AppTheme.warningColor,
                                size: 16.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '${artist['rating']}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                ' (${artist['reviews']})',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),

                          Spacer(),

                          // Price
                          Text(
                            '₹${artist['price']}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
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

          // Action Buttons
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariant,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtistProfilePage(
                            // Example: pass artistId or artist map if supported
                            // artistId: artist['id'],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.visibility, size: 16.sp),
                    label: Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.clientColor,
                      side: BorderSide(color: AppTheme.clientColor),
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingFormPage(artist: artist),
                        ),
                      );
                    },
                    icon: Icon(Icons.event, size: 16.sp),
                    label: Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.clientColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
