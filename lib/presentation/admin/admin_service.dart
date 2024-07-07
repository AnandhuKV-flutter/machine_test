import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllUsers() {
    return _db.collection('users').snapshots();
  }

  Stream<QuerySnapshot> getUserLocations(String userId) {
    return _db.collection('locations').where('user_id', isEqualTo: userId).snapshots();
  }
}
