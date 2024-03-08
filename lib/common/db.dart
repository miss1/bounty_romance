import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bounty_romance/common/userinfo_model.dart';
import 'package:bounty_romance/common/connection_model.dart';

class FireStoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create one user (Sign up)
  Future<void> createUser(UserInfoModel user) async {
    DocumentReference documentReference = _firestore.collection('users').doc(user.id);
    await documentReference.set(user.toMap());
  }

  // Get all users (Home page, list all users)
  Future<List<UserInfoModel>> getUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();
    List<UserInfoModel> userList = [];
    for (var document in querySnapshot.docs) {
      userList.add(UserInfoModel.fromSnapshot(document));
    }
    return userList;
  }

  // Get one user detail (user detail page)
  Future<UserInfoModel> getUserInfo(String id) async {
    DocumentReference documentReference = _firestore.collection('users').doc(id);
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      return UserInfoModel.fromSnapshot(snapshot);
    }
    return UserInfoModel.generateEmpty();
  }

  // Update one's profile
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

  // Update location in user profile
  Future<void> updateUserLocation(String city, double lat, double lng) async {
    String id = getCurrentUid();
    DocumentReference documentReference = _firestore.collection('users').doc(id);

    await documentReference.update({
      'city': city,
      'lat': lat,
      'lng': lng
    });
  }

  // Send a like request
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

  // After accept or reject one connection request, we need to delete the record
  Future<void> deleteLikeRequest(String id) async {
    String uid = getCurrentUid();

    DocumentReference documentReference = _firestore.collection('like_request').doc(uid)
        .collection('sender').doc(id);
    await documentReference.delete();
  }

  // Get all like requests. (user need to decide to accept or reject)
  Stream<List<UserInfoModel>> getLikeRequests() {
    String uid = getCurrentUid();
    return _firestore.collection("like_request").doc(uid).collection('sender')
        .snapshots()
        .map((snapshot) =>
        _snapshotsRequestItem(snapshot.docs)
    );
  }

  List<UserInfoModel> _snapshotsRequestItem(List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) {
    return snapshots.map(_snapshotRequestItem).toList();
  }

  UserInfoModel _snapshotRequestItem(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserInfoModel.fromSnapshot(snapshot);
  }

  // Accept a connection request
  Future<void> addConnection(UserInfoModel user) async {
    String uid = getCurrentUid();
    UserInfoModel currentUser = await getUserInfo(uid);

    String msgId = uid + user.id;

    DocumentReference documentReference = _firestore.collection('connection').doc(uid)
        .collection('friends').doc(user.id);
    await documentReference.set({
      'id': user.id,
      'name': user.name,
      'avatar': user.avatar,
      'msgId': msgId
    });

    DocumentReference documentReference2 = _firestore.collection('connection').doc(user.id)
        .collection('friends').doc(uid);
    await documentReference2.set({
      'id': currentUser.id,
      'name': currentUser.name,
      'avatar': currentUser.avatar,
      'msgId': msgId
    });

    await sendOneMessage(msgId, 'Hi. Thanks for your like. We can start talking to each other now.');
  }

  // Check if a user is already your connection
  Future<bool> checkConnectionStatus(String id) async {
    String uid = getCurrentUid();
    DocumentReference documentReference = _firestore.collection('connection').doc(uid)
        .collection('friends').doc(id);
    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) return true;
    return false;
  }

  // Send one message to others (chat)
  Future<void> sendOneMessage(String msgId, String msg) async {
    String uid = getCurrentUid();
    UserInfoModel currentUser = await getUserInfo(uid);

    await _firestore.collection('message').doc(msgId).collection('info').add({
      'senderId': uid,
      'senderName': currentUser.name,
      'senderAvatar': currentUser.avatar,
      'msg': msg,
      'time': DateTime.now().millisecondsSinceEpoch
    });
  }

  // Get all connections (message list)
  Stream<List<ConnectionModel>> getAllConnections() {
    String uid = getCurrentUid();
    return _firestore.collection("connection").doc(uid).collection('friends')
        .snapshots()
        .map((snapshot) =>
        _snapshotsConnectionItem(snapshot.docs)
    );
  }

  List<ConnectionModel> _snapshotsConnectionItem(List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) {
    return snapshots.map(_snapshotConnectionItem).toList();
  }

  ConnectionModel _snapshotConnectionItem(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ConnectionModel.fromSnapshot(snapshot);
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
