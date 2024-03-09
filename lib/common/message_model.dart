import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String msg;
  final int time;

  MessageModel(this.senderId, this.senderName, this.senderAvatar, this.msg, this.time);

  factory MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return MessageModel(
      data['senderId'],
      data['senderName'] ?? '',
      data['senderAvatar'] ?? '',
      data['msg'] ?? '',
      data['time'] ?? 0
    );
  }
}