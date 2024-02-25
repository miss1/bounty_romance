import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:bounty_romance/login_page.dart';
import 'package:bounty_romance/registration_page.dart';
import 'package:bounty_romance/all_profiles_page.dart';
import 'package:bounty_romance/upload_image.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginPage();
      }
    ),
    GoRoute(
      path: '/registration',
      builder: (context, state) {
        return const RegistrationPage();
      }
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const AllProfilesPage();
      }
    ),
    GoRoute(
      path: '/uploadAvatar',
      builder: (context, state) {
        return const UploadImage(defaultImgUrl: 'assets/default.jpg');
      }
    ),
  ],
);