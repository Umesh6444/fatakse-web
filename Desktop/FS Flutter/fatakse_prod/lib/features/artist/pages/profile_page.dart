import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/app_text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/user_model.dart';

/// ArtistProfilePage displays the artist's profile, including verification status and actions.
///
/// Shows skill and KYC verification, and allows requesting verification updates.

class ArtistProfilePage extends StatefulWidget {
  /// Creates an ArtistProfilePage.
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  ArtistProfilePage({
    Key? key,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : auth = auth ?? FirebaseAuth.instance,
       firestore = firestore ?? FirebaseFirestore.instance,
       super(key: key);

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

/// State for [ArtistProfilePage]. Handles loading profile data and verification actions.
class _ArtistProfilePageState extends State<ArtistProfilePage> {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  UserModel? _userModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth = widget.auth;
    _firestore = widget.firestore;
    _loadProfile();
  }

  /// Loads the artist's profile from Firestore.
  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = _auth.currentUser;
    if (user == null) return;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        _userModel = UserModel.fromJson({'id': user.uid, ...doc.data()!});
        _isLoading = false;
      });
    }
  }

  /// Requests skill verification for the artist.
  Future<void> _requestSkillVerification() async {
    if (_userModel == null) return;
    final artistData = _userModel!.roleSpecificData?.artistData;
    if (artistData == null) return;
    final updatedArtistData = artistData.copyWith(skillStatus: 'pending');
    final updatedUser = _userModel!.copyWith(
      roleSpecificData: _userModel!.roleSpecificData?.copyWith(
        artistData: updatedArtistData,
      ),
    );
    await _firestore.collection('users').doc(_userModel!.id).update({
      'roleSpecificData.artistData.skillStatus': 'pending',
    });
    setState(() => _userModel = updatedUser);
  }

  /// Requests KYC verification for the artist.
  Future<void> _requestKycVerification() async {
    if (_userModel == null) return;
    final artistData = _userModel!.roleSpecificData?.artistData;
    if (artistData == null) return;
    final updatedArtistData = artistData.copyWith(kycStatus: 'pending');
    final updatedUser = _userModel!.copyWith(
      roleSpecificData: _userModel!.roleSpecificData?.copyWith(
        artistData: updatedArtistData,
      ),
    );
    await _firestore.collection('users').doc(_userModel!.id).update({
      'roleSpecificData.artistData.kycStatus': 'pending',
    });
    setState(() => _userModel = updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final artistData = _userModel?.roleSpecificData?.artistData;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Artist Profile',
          style: AppTextStyles.headline.copyWith(
            color:
                Theme.of(context).appBarTheme.titleTextStyle?.color ??
                Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${_userModel?.fullName ?? ''}',
              style: AppTextStyles.headline,
            ),
            SizedBox(height: 16.h),
            if (artistData != null) ...[
              // Skill Verification Status
              Row(
                children: [
                  Icon(
                    artistData.skillStatus == 'approved'
                        ? Icons.verified
                        : artistData.skillStatus == 'pending'
                        ? Icons.hourglass_top
                        : Icons.error,
                    color: artistData.skillStatus == 'approved'
                        ? Colors.green
                        : artistData.skillStatus == 'pending'
                        ? Colors.orange
                        : Colors.red,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Skill Verification: '
                      '${artistData.skillStatus == 'approved'
                          ? 'Verified'
                          : artistData.skillStatus == 'pending'
                          ? 'Pending'
                          : 'Not Verified'}',
                      style: AppTextStyles.body,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (artistData.skillStatus != 'approved' &&
                      artistData.skillStatus != 'pending')
                    TextButton(
                      onPressed: _requestSkillVerification,
                      child: Text(
                        'Request Verification',
                        style: AppTextStyles.title,
                      ),
                    ),
                ],
              ),
              // KYC Verification Status
              Row(
                children: [
                  Icon(
                    artistData.kycStatus == 'approved'
                        ? Icons.verified
                        : artistData.kycStatus == 'pending'
                        ? Icons.hourglass_top
                        : Icons.error,
                    color: artistData.kycStatus == 'approved'
                        ? Colors.green
                        : artistData.kycStatus == 'pending'
                        ? Colors.orange
                        : Colors.red,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'KYC: '
                      '${artistData.kycStatus == 'approved'
                          ? 'Verified'
                          : artistData.kycStatus == 'pending'
                          ? 'Pending'
                          : 'Not Verified'}',
                      style: AppTextStyles.body,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (artistData.kycStatus != 'approved' &&
                      artistData.kycStatus != 'pending')
                    TextButton(
                      onPressed: _requestKycVerification,
                      child: Text('Request KYC', style: AppTextStyles.title),
                    ),
                ],
              ),
              if (!(artistData.skillStatus == 'approved' &&
                  artistData.kycStatus == 'approved'))
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    'You must complete Skill and KYC verification to go live.',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (artistData.skillStatus == 'approved' &&
                  artistData.kycStatus == 'approved')
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Text(
                    'You are verified and can go live!',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
