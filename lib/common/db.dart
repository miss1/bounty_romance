import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bounty_romance/common/userinfo_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserInfoModel user) async {
    DocumentReference documentReference = _firestore.collection('users').doc(user.id);
    await documentReference.set(user.toMap());
  }

  Future<List<UserInfoModel>> getUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    List<UserInfoModel> userList = [];
    for (var document in querySnapshot.docs) {
      userList.add(UserInfoModel.fromSnapshot(document));
    }
    return userList;
  }

  Future<UserInfoModel> getUserInfo(String id) async {
    DocumentReference documentReference = _firestore.collection('users').doc(id);
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      return UserInfoModel.fromSnapshot(snapshot);
    }
    return UserInfoModel.generateEmpty();
  }

  Future<void> updateUserProfile(UserInfoModel user) async {
    String id = getCurrentUid();
    DocumentReference documentReference = _firestore.collection('users').doc(id);

    await documentReference.update({
      'avatar': user.avatar,
      'gender': user.gender,
      'name': user.name,
      'age': user.age,
      'intro': user.intro
    });
  }

  Future<void> updateUserLocation(String city, double lat, double lng) async {
    String id = getCurrentUid();
    DocumentReference documentReference = _firestore.collection('users').doc(id);

    await documentReference.update({
      'city': city,
      'lat': lat,
      'lng': lng
    });
  }

  Future<void> addLikeRequest(String id) async {
    String uid = getCurrentUid();
    UserInfoModel currentUser = await getUserInfo(uid);

    DocumentReference documentReference = _firestore.collection('like_request').doc(id)
        .collection('sender').doc(uid);

    await documentReference.set({
      'id': uid,
      'name': currentUser.name,
      'avatar': currentUser.avatar
    });
  }

  String getCurrentUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return '';
  }
}
