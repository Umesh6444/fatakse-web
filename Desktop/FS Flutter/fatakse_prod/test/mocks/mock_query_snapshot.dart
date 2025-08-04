import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockQuerySnapshot<T> extends Mock implements QuerySnapshot<T> {
  @override
  List<QueryDocumentSnapshot<T>> get docs => <QueryDocumentSnapshot<T>>[];
}
