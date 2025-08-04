import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/user_model.dart';

class AdminVerificationDashboard extends StatefulWidget {
  const AdminVerificationDashboard({super.key});

  @override
  State<AdminVerificationDashboard> createState() =>
      _AdminVerificationDashboardState();
}

class _AdminVerificationDashboardState
    extends State<AdminVerificationDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _pendingArtists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingArtists();
  }

  Future<void> _loadPendingArtists() async {
    setState(() => _isLoading = true);
    final query = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'artist')
        .get();
    final artists = query.docs
        .map((doc) => UserModel.fromJson({'id': doc.id, ...doc.data()}))
        .where((user) {
          final artistData = user.roleSpecificData?.artistData;
          return artistData != null &&
              (artistData.kycStatus == 'pending' ||
                  artistData.skillStatus == 'pending');
        })
        .toList();
    setState(() {
      _pendingArtists = artists;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(
    UserModel user, {
    String? kycStatus,
    String? skillStatus,
  }) async {
    final artistData = user.roleSpecificData?.artistData;
    if (artistData == null) return;
    final updatedArtistData = artistData.copyWith(
      kycStatus: kycStatus ?? artistData.kycStatus,
      skillStatus: skillStatus ?? artistData.skillStatus,
    );
    final updatedUser = user.copyWith(
      roleSpecificData: user.roleSpecificData?.copyWith(
        artistData: updatedArtistData,
      ),
    );
    await _firestore
        .collection('users')
        .doc(user.id)
        .update(updatedUser.toJson());
    _loadPendingArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Verification Dashboard')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pendingArtists.length,
              itemBuilder: (context, index) {
                final user = _pendingArtists[index];
                final artistData = user.roleSpecificData?.artistData;
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(user.fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('KYC: ${artistData?.kycStatus ?? 'N/A'}'),
                        Text('Skill: ${artistData?.skillStatus ?? 'N/A'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (artistData?.kycStatus == 'pending') ...[
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Approve KYC',
                            onPressed: () =>
                                _updateStatus(user, kycStatus: 'approved'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: 'Reject KYC',
                            onPressed: () =>
                                _updateStatus(user, kycStatus: 'rejected'),
                          ),
                        ],
                        if (artistData?.skillStatus == 'pending') ...[
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Approve Skill',
                            onPressed: () =>
                                _updateStatus(user, skillStatus: 'approved'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            tooltip: 'Reject Skill',
                            onPressed: () =>
                                _updateStatus(user, skillStatus: 'rejected'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
