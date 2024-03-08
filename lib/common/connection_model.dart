import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionModel {
  final String id;
  final String name;
  final String avatar;
  final String msgId;

  ConnectionModel(this.id, this.name, this.avatar, this.msgId);

  factory ConnectionModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ConnectionModel(
        data['id'],
        data['name'] ?? '',
        data['avatar'] ?? '',
        data['msgId'] ?? ''
    );
  }
}