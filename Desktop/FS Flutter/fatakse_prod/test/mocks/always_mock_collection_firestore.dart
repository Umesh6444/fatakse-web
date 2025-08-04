import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'mock_query.mocks.dart';

class AlwaysMockCollectionFirestore extends Mock implements FirebaseFirestore {
  final CollectionReference<Map<String, dynamic>> _mockCollection;
  final MockQuery _mockQuery = MockQuery();
  AlwaysMockCollectionFirestore(this._mockCollection);

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _mockCollection;

  // If .where() is called directly on this, return a mock Query
  // Not an override, but provided for test safety
  MockQuery where(
    Object field, {
    bool? isNull,
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
  }) {
    return _mockQuery;
  }
}
