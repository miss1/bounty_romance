import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUser(Map<String, dynamic> user) async {
    await _firestore.collection("users").add(user);
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}