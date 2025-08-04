import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';

class SavedJobsService {
  final FirebaseFirestore _firestore;
  static const String _hiveBox = 'saved_jobs';

  SavedJobsService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Returns a stream of saved job IDs for the current user
  Stream<List<String>> savedJobIdsStream(String userId) {
    if (kIsWeb) {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .snapshots()
          .map((snap) => snap.docs.map((doc) => doc.id).toList());
    } else {
      // Listen to both Firestore and Hive for offline support
      return Hive.box(_hiveBox).watch().map((_) {
        final box = Hive.box(_hiveBox);
        return box.keys.cast<String>().toList();
      });
    }
  }

  Future<void> saveJob(
    String userId,
    String jobId,
    Map<String, dynamic> jobData,
  ) async {
    if (kIsWeb) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .set(jobData);
    } else {
      final box = await Hive.openBox(_hiveBox);
      await box.put(jobId, jobData);
      // Optionally sync to Firestore in background
      _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .set(jobData);
    }
  }

  Future<void> unsaveJob(String userId, String jobId) async {
    if (kIsWeb) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .delete();
    } else {
      final box = await Hive.openBox(_hiveBox);
      await box.delete(jobId);
      // Optionally sync to Firestore in background
      _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .delete();
    }
  }

  Future<bool> isJobSaved(String userId, String jobId) async {
    if (kIsWeb) {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .get();
      return doc.exists;
    } else {
      final box = await Hive.openBox(_hiveBox);
      return box.containsKey(jobId);
    }
  }
}
