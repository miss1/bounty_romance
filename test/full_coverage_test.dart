// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:bounty_romance/all_profiles_page.dart';
import 'package:bounty_romance/common/db.dart';
import 'package:bounty_romance/common/firebase_options.dart';
import 'package:bounty_romance/login_page.dart';
import 'package:bounty_romance/main.dart';
import 'package:bounty_romance/registration_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('main widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(Login), findsOneWidget);
  });

  testWidgets('login page: tap clear icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Login(title: 'Bounty Romance'),
    ));
    expect(find.byType(Login), findsOneWidget);

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
      home: Login(title: 'Bounty Romance'),
    ));
    expect(find.byType(Login), findsOneWidget);

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
    await tester.pumpWidget(const MaterialApp(
      home: Login(title: 'Bounty Romance'),
    ));
    expect(find.byType(Login), findsOneWidget);

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

  testWidgets('registration page: form validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
    expect(find.byType(RegistrationPage), findsOneWidget);

    await tester.enterText(find.byKey(const Key('nickname')), '');
    await tester.enterText(find.byKey(const Key('email')), 'Hello');
    await tester.enterText(find.byKey(const Key('password')), '123a');

    expect(find.text('Nickname can not be null'), findsNothing);
    expect(find.text('Please enter a valid email'), findsNothing);
    expect(find.text('Password should be at least 6 characters'), findsNothing);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Nickname can not be null'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password should be at least 6 characters'), findsOneWidget);
  });

  testWidgets('registration page: click sign in', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
    expect(find.byType(RegistrationPage), findsOneWidget);

    expect(find.byType(Login), findsNothing);
    Finder signIn = find.text('Sign in');
    expect(signIn, findsOneWidget);

    await tester.tap(signIn);
    await tester.pumpAndSettle();
    expect(find.byType(Login), findsOneWidget);
  });
}
