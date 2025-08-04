import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataSeedingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> seedArtistData() async {
    try {
      // Check if we already have artist data
      final existingArtists = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'artist')
          .limit(1)
          .get();

      if (existingArtists.docs.isNotEmpty) {
        debugPrint('Artist data already exists, skipping seeding');
        return;
      }

      debugPrint('Seeding artist data...');

      final artists = [
        {
          'firstName': 'Arjun',
          'lastName': 'Singh',
          'email': 'arjun.singer@example.com',
          'role': 'artist',
          'categories': ['Singer', 'Musician'],
          'location': 'Mumbai',
          'bio':
              'Professional singer with 10+ years experience in Bollywood and classical music',
          'isActive': true,
          'isVerified': true,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        },
        {
          'firstName': 'Priya',
          'lastName': 'Sharma',
          'email': 'priya.dancer@example.com',
          'role': 'artist',
          'categories': ['Dancer', 'Choreographer'],
          'location': 'Delhi',
          'bio':
              'Classical and contemporary dance expert, specializing in Kathak and Bollywood',
          'isActive': true,
          'isVerified': true,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        },
        {
          'firstName': 'DJ',
          'lastName': 'Vikram',
          'email': 'dj.vikram@example.com',
          'role': 'artist',
          'categories': ['DJ', 'Music Producer'],
          'location': 'Bangalore',
          'bio':
              'Electronic music DJ and producer with expertise in house, techno, and Bollywood remixes',
          'isActive': true,
          'isVerified': true,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        },
        {
          'firstName': 'The Melodies',
          'lastName': 'Band',
          'email': 'melodies.band@example.com',
          'role': 'artist',
          'categories': ['Band', 'Live Music'],
          'location': 'Mumbai',
          'bio':
              'Professional rock and acoustic band for weddings and corporate events',
          'isActive': true,
          'isVerified': true,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        },
        {
          'firstName': 'Rohit',
          'lastName': 'Comedy',
          'email': 'rohit.comedian@example.com',
          'role': 'artist',
          'categories': ['Comedian', 'Stand-up'],
          'location': 'Delhi',
          'bio':
              'Stand-up comedian and entertainer for corporate events and parties',
          'isActive': true,
          'isVerified': true,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        },
        {
          'firstName': 'Magic',
          'lastName': 'Mantra',
          'email': 'magic.mantra@example.com',
          'role': 'artist',
          'categories': ['Magician', 'Entertainer'],
          'location': 'Chennai',
          'bio': 'Professional magician and illusionist for all age groups',
          'isActive': true,
          'isVerified': true,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        },
      ];

      final batch = _firestore.batch();

      for (final artist in artists) {
        final docRef = _firestore.collection('users').doc();
        batch.set(docRef, artist);
      }

      await batch.commit();
      debugPrint('Successfully seeded ${artists.length} artists');
    } catch (e) {
      debugPrint('Error seeding artist data: $e');
    }
  }

  static Future<void> seedSamplePortfolio(String artistUserId) async {
    try {
      final portfolioItems = [
        {
          'userId': artistUserId,
          'title': 'Wedding Performance',
          'description':
              'Beautiful classical performance at a destination wedding',
          'category': 'Performance',
          'imageUrl': 'https://via.placeholder.com/300x200',
          'createdAt': Timestamp.now(),
        },
        {
          'userId': artistUserId,
          'title': 'Corporate Event',
          'description':
              'High-energy performance for annual company celebration',
          'category': 'Performance',
          'imageUrl': 'https://via.placeholder.com/300x200',
          'createdAt': Timestamp.now(),
        },
      ];

      for (final item in portfolioItems) {
        await _firestore.collection('portfolios').add(item);
      }

      debugPrint('Seeded portfolio items for user $artistUserId');
    } catch (e) {
      debugPrint('Error seeding portfolio: $e');
    }
  }

  static Future<void> seedSamplePricing(String artistUserId) async {
    try {
      final pricingPackages = [
        {
          'userId': artistUserId,
          'name': 'Basic Performance',
          'description': 'Simple performance for small gatherings',
          'price': 15000,
          'duration': 'Hour',
          'features': [
            '2-hour performance',
            'Sound system included',
            'Travel within city',
          ],
          'createdAt': Timestamp.now(),
        },
        {
          'userId': artistUserId,
          'name': 'Premium Package',
          'description': 'Complete entertainment package for large events',
          'price': 35000,
          'duration': 'Event',
          'features': [
            '4-hour performance',
            'Professional sound system',
            'Costume changes',
            'Travel anywhere in state',
          ],
          'createdAt': Timestamp.now(),
        },
      ];

      for (final package in pricingPackages) {
        await _firestore.collection('pricing').add(package);
      }

      debugPrint('Seeded pricing packages for user $artistUserId');
    } catch (e) {
      debugPrint('Error seeding pricing: $e');
    }
  }
}
