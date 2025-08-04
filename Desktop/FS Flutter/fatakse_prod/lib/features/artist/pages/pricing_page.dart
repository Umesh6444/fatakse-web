import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/models/user_model.dart';

import '../../../config/theme/app_theme.dart';
import '../../../config/app_text_styles.dart';

/// PricingPage allows artists to manage their service pricing packages.
///
/// Integrates with Firestore for CRUD operations on pricing data.

class PricingPage extends StatefulWidget {
  /// Creates a PricingPage.
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  PricingPage({Key? key, FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance,
      super(key: key);

  @override
  State<PricingPage> createState() => _PricingPageState();
}

/// State for [PricingPage]. Handles loading, adding, and deleting pricing packages.
class _PricingPageState extends State<PricingPage> {
  // Example commission and fee settings (replace with your actual logic or fetch from backend)
  static const double gstPercent = 18.0;
  static const double platformFeePercent = 5.0;
  static const Map<String, double> cityCommission = {
    'Mumbai': 10.0,
    'Delhi': 8.0,
    'Bangalore': 7.0,
    'Other': 5.0,
  };
  static const Map<String, double> roleCommission = {
    'artist': 10.0,
    'vendor': 12.0,
    'event_planner': 8.0,
    'production_house': 7.0,
    'client': 0.0,
  };

  UserModel? _userModel;
  late final FirebaseFirestore _firestore;
  late final FirebaseAuth _auth;

  bool _isLoading = false;
  List<Map<String, dynamic>> _pricingPackages = [];

  @override
  void initState() {
    super.initState();
    _firestore = widget.firestore;
    _auth = widget.auth;
    _loadUserAndPricing();
  }

  Future<void> _loadUserAndPricing() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          _userModel = UserModel.fromJson(userDoc.data()!);
        }
      }
    } catch (e) {
      debugPrint('User load error: $e');
    }
    await _loadPricing();
  }

  /// Loads the user's pricing packages from Firestore.
  Future<void> _loadPricing() async {
    setState(() => _isLoading = true);

    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('pricing')
            .where('userId', isEqualTo: user.uid)
            .get();

        final packages = querySnapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList();

        // Sort by price in Dart since Firestore orderBy might not be indexed
        packages.sort((a, b) {
          final aPrice = a['price'] as num? ?? 0;
          final bPrice = b['price'] as num? ?? 0;
          return aPrice.compareTo(bPrice); // Ascending order
        });

        setState(() {
          _pricingPackages = packages;
        });
      }
    } catch (e) {
      debugPrint('Pricing Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading pricing: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Shows a dialog to add a new pricing package.
  Future<void> _addPricingPackage() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _PricingDialog(),
    );

    if (result != null) {
      await _savePricingPackage(result);
    }
  }

  /// Saves a new pricing package to Firestore.
  Future<void> _savePricingPackage(Map<String, dynamic> package) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('pricing').add({
          'userId': user.uid,
          'name': package['name'],
          'description': package['description'],
          'price': package['price'],
          'duration': package['duration'],
          'features': package['features'],
          'createdAt': Timestamp.now(),
        });

        await _loadPricing();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pricing package added successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving pricing package: $e')),
      );
    }
  }

  /// Deletes a pricing package from Firestore.
  Future<void> _deletePricingPackage(String packageId) async {
    try {
      await _firestore.collection('pricing').doc(packageId).delete();
      await _loadPricing();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pricing package deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting pricing package: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Pricing Packages',
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
                    'Set competitive pricing for your services',
                    style: AppTextStyles.title.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  child: _pricingPackages.isEmpty
                      ? _buildEmptyState()
                      : _buildPricingList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: "pricing_fab",
        onPressed: _addPricingPackage,
        backgroundColor: AppTheme.artistColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Builds the empty state widget when no pricing packages exist.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monetization_on,
            size: 64.sp,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No pricing packages set',
            style: AppTextStyles.title.copyWith(color: AppTheme.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create pricing packages to attract clients',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Builds the list of pricing packages.
  Widget _buildPricingList() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _pricingPackages.length,
      itemBuilder: (context, index) {
        final package = _pricingPackages[index];
        final features = List<String>.from(package['features'] ?? []);
        final double price = (package['price'] as num?)?.toDouble() ?? 0;
        final String city = _userModel?.location?.city ?? 'Other';
        final String role = _userModel?.role ?? 'artist';
        final double commission =
            cityCommission[city] ?? cityCommission['Other']!;
        final double roleComm = roleCommission[role] ?? 0.0;
        final double gst = gstPercent;
        final double platformFee = platformFeePercent;
        final double totalDeductions =
            commission + roleComm + gst + platformFee;
        final double netPayout = price * (1 - totalDeductions / 100);

        return Card(
          margin: EdgeInsets.only(bottom: 16.h),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package['name'] ?? '',
                            style: AppTextStyles.headline.copyWith(
                              color: AppTheme.artistColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '\u20b9${package['price']} / ${package['duration']}',
                            style: AppTextStyles.title.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Net Payout: \u20b9${netPayout.toStringAsFixed(2)} (after commission, GST, platform fee)',
                            style: AppTextStyles.caption.copyWith(
                              color: AppTheme.successColor,
                            ),
                          ),
                          Text(
                            'Deductions: Commission $commission%, Role $roleComm%, GST $gst%, Platform Fee $platformFee%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppTheme.errorColor),
                      onPressed: () => _deletePricingPackage(package['id']),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  package['description'] ?? '',
                  style: AppTextStyles.body.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (features.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'Includes:',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ...features.map(
                    (feature) => Padding(
                      padding: EdgeInsets.only(left: 16.w, bottom: 2.h),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16.sp,
                            color: AppTheme.successColor,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(feature, style: AppTextStyles.caption),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Dialog for adding a new pricing package.
class _PricingDialog extends StatefulWidget {
  @override
  _PricingDialogState createState() => _PricingDialogState();
}

/// State for [_PricingDialog]. Handles form input for pricing package details.
class _PricingDialogState extends State<_PricingDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _featureController = TextEditingController();

  String _selectedDuration = 'Hour';
  final List<String> _features = [];

  final List<String> _durations = ['Hour', 'Day', 'Event', 'Month', 'Project'];

  /// Adds a feature to the pricing package.
  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  /// Removes a feature from the pricing package.
  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Pricing Package', style: AppTextStyles.headline),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Package Name',
                hintText: 'e.g., Basic Performance',
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe what\'s included',
              ),
              maxLines: 2,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    key: const Key('priceField'),
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (₹)',
                      hintText: '5000',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    decoration: const InputDecoration(labelText: 'Per'),
                    items: _durations.map((duration) {
                      return DropdownMenuItem(
                        value: duration,
                        child: Text(duration, style: AppTextStyles.body),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedDuration = value!);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _featureController,
                    decoration: const InputDecoration(
                      labelText: 'Add Feature',
                      hintText: 'e.g., 2-hour performance',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _addFeature),
              ],
            ),
            if (_features.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ListView.builder(
                  itemCount: _features.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      title: Text(_features[index], style: AppTextStyles.body),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () => _removeFeature(index),
                      ),
                    );
                  },
                ),
              ),
            ],
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
            if (_nameController.text.isNotEmpty &&
                _priceController.text.isNotEmpty) {
              Navigator.pop(context, {
                'name': _nameController.text,
                'description': _descriptionController.text,
                'price': double.tryParse(_priceController.text) ?? 0,
                'duration': _selectedDuration,
                'features': _features,
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
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _featureController.dispose();
    super.dispose();
  }
}
