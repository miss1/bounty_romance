import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/nav_notifier.dart';

class HomePageNavBar extends StatefulWidget {
  final Widget child;
  const HomePageNavBar({super.key, required this.child});

  @override
  State<HomePageNavBar> createState() => _HomePageNavBar();
}

class _HomePageNavBar extends State<HomePageNavBar> {
  static const List pages = ['/home', '/messages', '/myProfile'];

  Future<void> logoutFn(context) async {
    await FirebaseAuth.instance.signOut();
    GoRouter.of(context).replace('/');
  }

  void onItemTapped(BuildContext context, int index) {
    if (index == context.read<NavNotifier>().currentIndex) return;
    GoRouter.of(context).go(pages[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bounty Romance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              logoutFn(context);
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Profile',
          ),
        ],
        currentIndex: Provider.of<NavNotifier>(context).currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (int index) {
          onItemTapped(context, index);
        },
      ),
    );
  }
}