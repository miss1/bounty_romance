import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widget_profile.dart';

class UserProfilePage extends StatelessWidget {
  final String uid;
  const UserProfilePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bounty Romance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: UserProfile(pageType: 'user', uid: uid),
        )
      )
    );
  }
}