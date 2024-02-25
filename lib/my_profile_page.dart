import 'package:flutter/cupertino.dart';
import 'widget_profile.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserProfile(pageType: 'me', uid: '');
  }
}