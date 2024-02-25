import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:bounty_romance/home_nav_bar.dart';
import 'package:bounty_romance/login_page.dart';
import 'package:bounty_romance/registration_page.dart';
import 'package:bounty_romance/all_profiles_page.dart';
import 'package:bounty_romance/upload_image_page.dart';
import 'package:bounty_romance/user_profile_page.dart';

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
      path: '/uploadAvatar',
      builder: (context, state) {
        String defaultImg = state.extra as String;
        return UploadImage(defaultImgUrl: defaultImg);
      }
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return HomePageNavBar(
          key: GlobalKey(debugLabel: "HomeScreen"),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return const AllProfilesPage();
          }
        ),
        GoRoute(
          path: '/myProfile',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return const UserProfilePage();
          }
        ),
      ],
    )
  ],
);