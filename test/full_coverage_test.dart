// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:bounty_romance/all_profiles_page.dart';
import 'package:bounty_romance/db.dart';
import 'package:bounty_romance/firebase_options.dart';
import 'package:bounty_romance/login_page.dart';
import 'package:bounty_romance/main.dart';
import 'package:bounty_romance/registration_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('main.dart test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(Login), findsOneWidget);
  });
}
