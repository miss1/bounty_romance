import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel {
  final String id;
  final String name;
  final String email;
  final String age;
  final String intro;
  final int gender;
  final String avatar;
  final String city;
  final double lat;
  final double lng;

  UserInfoModel({required this.id, required this.name, required this.email, required this.age,
    required this.intro, required this.gender, required this.avatar,
    required this.city, required this.lat, required this.lng});

  factory UserInfoModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserInfoModel(
        id: data['id'],
        name: data['name'] ?? '',
        email: data['email'],
        age: data['age'] ?? '0',
        intro: data['intro'] ?? '',
        gender: data['gender'] ?? 0,
        avatar: data['avatar'] ?? '',
        city: data['city'] ?? '-',
        lat: data['lat'] ?? 0.0,
        lng: data['lng'] ?? 0.0
    );
  }

  factory UserInfoModel.generateEmpty() {
    return UserInfoModel(
        id: '',
        name: '',
        email: '',
        age: '',
        intro: '',
        gender: 0,
        avatar: '',
        city: '-',
        lat: 0.0,
        lng: 0.0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "age": age,
      "intro": intro,
      "gender": gender,
      "avatar": avatar,
      "city": city,
      "lat": lat,
      "lng": lng
    };
  }
}