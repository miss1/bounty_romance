import 'package:flutter/material.dart';
import 'widget_profile.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const UserProfile(pageType: 'me', uid: ''),
    );
  }
}