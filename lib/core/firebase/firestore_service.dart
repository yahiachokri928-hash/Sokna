import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore? _injectedFirestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _injectedFirestore = firestore;

  FirebaseFirestore get firestore =>
      _injectedFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String collectionPath) {
    return firestore.collection(collectionPath);
  }

  DocumentReference<Map<String, dynamic>> doc(String documentPath) {
    return firestore.doc(documentPath);
  }

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      collection('users');

  CollectionReference<Map<String, dynamic>> get listingsCollection =>
      collection('listings');
}

typedef FirebaseFirestoreService = FirestoreService;
