import 'package:bounty_romance/common/router.dart';
import 'package:bounty_romance/common/nav_notifier.dart';
import 'package:provider/provider.dart';
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:bounty_romance/common/db.dart';
import 'package:bounty_romance/main.dart';
import 'package:bounty_romance/all_profiles_page.dart';
import 'package:bounty_romance/login_page.dart';
import 'package:bounty_romance/registration_page.dart';
import 'package:bounty_romance/upload_image_page.dart';
import 'package:bounty_romance/home_nav_bar.dart';
import 'package:bounty_romance/user_profile_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login page: tap clear icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));
    expect(find.byType(LoginPage), findsOneWidget);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('email')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('password')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('password')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);
  });

  testWidgets('login page: form validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    await tester.enterText(find.byKey(const Key('password')), '123a');

    expect(find.text('Please enter a valid email'), findsNothing);
    expect(find.text('Password should be at least 6 characters'), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password should be at least 6 characters'), findsOneWidget);
  });

  testWidgets('login page: click signup', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    expect(find.byType(LoginPage), findsOneWidget);

    expect(find.byType(RegistrationPage), findsNothing);
    Finder signup = find.text('Sign up');
    expect(signup, findsOneWidget);

    await tester.tap(signup);
    await tester.pumpAndSettle();
    expect(find.byType(RegistrationPage), findsOneWidget);
  });

  testWidgets('registration page: tap clear icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
    expect(find.byType(RegistrationPage), findsOneWidget);

    // test nickname filed: tap clear icon
    await tester.enterText(find.byKey(const Key('nickname')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('nickname')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('email')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);

    // test email filed: tap clear icon
    await tester.enterText(find.byKey(const Key('password')), 'Hello');
    expect(find.text('Hello'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('password')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Hello'), findsNothing);
  });

  testWidgets('upload image page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: UploadImage(defaultImgUrl: '',)
    ));
    expect(find.byType(UploadImage), findsOneWidget);
  });

  // testWidgets('home nav bar', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //       MultiProvider(
  //           providers: [
  //             ChangeNotifierProvider(
  //               create: (context) => NavNotifier(),
  //             ),
  //           ],
  //           child: const MaterialApp(
  //             home: HomePageNavBar(child: UserProfilePage(uid: '',)),
  //           )
  //       )
  //   );
  //   expect(find.byType(HomePageNavBar), findsOneWidget);
  // });
}
