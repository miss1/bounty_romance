
import 'dart:async';

import 'package:bounty_romance/common/connection_model.dart';
import 'package:bounty_romance/common/message_model.dart';
import 'package:bounty_romance/common/userinfo_model.dart';
import 'package:bounty_romance/common/router.dart';
import 'package:bounty_romance/common/nav_notifier.dart';
import 'package:bounty_romance/edit_profile_page.dart';
import 'package:bounty_romance/like_request_page.dart';
import 'package:bounty_romance/message_list_page.dart';
import 'package:bounty_romance/message_page.dart';
import 'package:bounty_romance/my_profile_page.dart';
import 'package:bounty_romance/widget_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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
import 'package:bounty_romance/map_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'full_coverage_test.mocks.dart';

// Mock Firebase
@GenerateMocks([FireStoreService, DocumentSnapshot])

class MockGoRouter extends Mock {
  void push(String route, {String extra});
}

UserInfoModel getMockUserInfo () {
  return UserInfoModel(
      id: '0',
      name: 'Kimmy',
      email: 'test1@gmail.com',
      age: '29',
      intro: 'love me',
      gender: 0,
      avatar: '',
      city: '',
      lat: 0.0,
      lng: 0.0
  );
}

void main() {
  // Create a mock FirebaseAuth instance
  final FireStoreService mockFireStoreService = MockFireStoreService();
  final DocumentSnapshot mockDocumentSnapshot = MockDocumentSnapshot();
  MockGoRouter mockGoRouter;

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

  test('Nav Notifier Test', () {
    NavNotifier navNotifier = NavNotifier();

    expect(navNotifier.currentIndex, 0);

    navNotifier.changeNavBar(1);

    expect(navNotifier.currentIndex, 1);

    bool listenerCalled = false;
    navNotifier.addListener(() {
      listenerCalled = true;
    });

    navNotifier.notifyListeners();

    expect(listenerCalled, isTrue);
  });

  test('UserInfoModel Test', () {
    // create a UserInfoModel instance
    UserInfoModel userInfo = getMockUserInfo();

    expect(userInfo.id, '0');
    expect(userInfo.name, 'Kimmy');
    expect(userInfo.email, 'test1@gmail.com');
    expect(userInfo.age, '29');
    expect(userInfo.intro, 'love me');
    expect(userInfo.gender, 0);
    expect(userInfo.avatar, '');
    expect(userInfo.city, '');

    // test generateEmpty function
    UserInfoModel emptyUserInfo = UserInfoModel.generateEmpty();
    expect(emptyUserInfo.id, '');
    expect(emptyUserInfo.name, '');
    expect(emptyUserInfo.email, '');
    expect(emptyUserInfo.age, '');
    expect(emptyUserInfo.intro, '');
    expect(emptyUserInfo.gender, 0);
    expect(emptyUserInfo.avatar, '');
    expect(emptyUserInfo.city, '-');

    // test toMap function
    Map<String, dynamic> userInfoMap = userInfo.toMap();
    expect(userInfoMap['id'], '0');
    expect(userInfoMap['name'], 'Kimmy');
    expect(userInfoMap['email'], 'test1@gmail.com');
    expect(userInfoMap['age'], '29');
    expect(userInfoMap['intro'], 'love me');
    expect(userInfoMap['gender'], 0);
    expect(userInfoMap['avatar'], '');
    expect(userInfoMap['city'], '');
  });

  test('UserInfoModel Test with DocumentSnapshot', () {
    // test fromSnapshot function
    Map<String, dynamic> mockSnapshotData = {
      'id': '0',
      'name': 'John Doe',
      'email': 'test2@gmail.com',
      'age': '18',
      'intro': 'haha',
      'gender': 0
    };
    when(mockDocumentSnapshot.data()).thenAnswer((_) => mockSnapshotData);
    UserInfoModel snapUserInfo = UserInfoModel.fromSnapshot(mockDocumentSnapshot);
    expect(snapUserInfo.id, '0');
    expect(snapUserInfo.name, 'John Doe');
  });

  // test all profile page widget
  testWidgets('AllProfilePage: no user Test', (WidgetTester tester) async {
    when(mockFireStoreService.getUsers()).thenAnswer((_) async => Future.value([]));
    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "0");
    // Build the widget
    // await tester.pumpWidget(
    //   Provider.value<FireStoreService>(
    //     value: mockFireStoreService,
    //     child: const MaterialApp(home: AllProfilesPage(),),
    //   )
    // );

    await tester.pumpWidget(
        MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => NavNotifier(),
              ),
              Provider(create: (context) => mockFireStoreService),
            ],
            child: const MaterialApp(home: AllProfilesPage()),
        )
    );

    await tester.pumpAndSettle();
    // validate
    expect(find.text('No user found!'), findsOneWidget);
    expect(find.byType(AllProfilesPage), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(PageView), findsNothing);
  });

  // test all profile page widget - has users
  testWidgets('AllProfilePage: one user Test', (WidgetTester tester) async {
    UserInfoModel user = getMockUserInfo();
    //mockGoRouter = MockGoRouter();

    when(mockFireStoreService.getUsers()).thenAnswer((_) async => Future.value([user]));
    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "1");
    when(mockFireStoreService.getUserInfo('0')).thenAnswer((_) => Future.value(user));

    final goRouter = GoRouter(
      initialLocation: '/home', // Start at '/home'// Adjust routerNeglect as needed
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const AllProfilesPage(),
        ),
        GoRoute(
            path: '/userProfile',
            builder: (context, state) {
              String userId = state.extra as String;
              return UserProfilePage(uid: userId);
            }
        ),
      ],
    );

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavNotifier(),
            ),
            Provider(create: (context) => mockFireStoreService),
          ],
          child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  title: 'Bounty Romance',
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  routerConfig: goRouter,
                );
              }
          ),
        )
    );
    await tester.pumpAndSettle();


    // await tester.pumpWidget(
    //     MultiProvider(
    //       providers: [
    //         ChangeNotifierProvider(
    //           create: (context) => NavNotifier(),
    //         ),
    //         Provider(create: (context) => mockFireStoreService),
    //       ],
    //       child: const MaterialApp(home: AllProfilesPage()),
    //     )
    // );
    // await tester.pumpAndSettle();

    // validate
    expect(find.text('Kimmy'), findsOneWidget);
    expect(find.text('29'), findsOneWidget);
    expect(find.byType(AllProfilesPage), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    // tap the profile
    await tester.tap(find.byType(Card));
    await tester.pumpAndSettle();
    // // Verify if GoRouter.of(context).push() is called with the correct arguments
    // verify(mockGoRouter.push('/userProfile', extra: '0')).called(1);
    expect(find.byType(UserProfilePage), findsOneWidget);
    expect(find.byType(UserProfile), findsOneWidget);
  });

  testWidgets('load map page', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MapPage(type: 'me', center: LatLng(0.0, 0.0),)
    ));
    expect(find.byType(MapPage), findsOneWidget);
  });

  testWidgets('widget profile page', (WidgetTester tester) async {
    UserInfoModel user = getMockUserInfo();

    when(mockFireStoreService.getUserInfo('0')).thenAnswer((_) async => Future.value(user));
    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "0");

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => NavNotifier(),
          ),
          Provider(create: (context) => mockFireStoreService),
        ],
        child: const MaterialApp(
          home: MyProfilePage()
        ),
      )
    );
    await tester.pumpAndSettle();

    expect(find.text('Kimmy'), findsOneWidget);
    expect(find.byType(UserProfile), findsOneWidget);
  });

  testWidgets('edit profile page', (WidgetTester tester) async {
    UserInfoModel user = getMockUserInfo();

    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "0");
    when(mockFireStoreService.getUserInfo('0')).thenAnswer((_) async => Future.value(user));

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider(create: (context) => mockFireStoreService),
          ],
          child: const MaterialApp(home: EditProfilePage()),
        )
    );
    await tester.pumpAndSettle();
    expect(find.byType(EditProfilePage), findsOneWidget);

    // clear btn
    expect(find.text('Kimmy'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('nickname')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('Kimmy'), findsNothing);

    expect(find.text('29'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('ageTextInput')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('29'), findsNothing);

    expect(find.text('love me'), findsOneWidget);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('introTextInput')),
      matching: find.byIcon(Icons.clear),
    ));
    await tester.pump();
    expect(find.text('love me'), findsNothing);
  });

  testWidgets('user profile page', (WidgetTester tester) async {
    UserInfoModel user = getMockUserInfo();

    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "0");
    when(mockFireStoreService.getUserInfo('0')).thenAnswer((_) async => Future.value(user));

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider(create: (context) => mockFireStoreService),
          ],
          child: MaterialApp(
            home: UserProfilePage(uid: '0',),
            builder: EasyLoading.init(),
          ),
        )
    );
    await tester.pumpAndSettle();

    expect(find.text('Kimmy'), findsOneWidget);
    expect(find.byType(UserProfilePage), findsOneWidget);

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byType(ElevatedButton);
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );
    when(mockFireStoreService.checkConnectionStatus('0')).thenAnswer((_) async => Future.value(false));
    when(mockFireStoreService.checkIfLikeRequestHasBeenSent('0')).thenAnswer((_) async => Future.value(false));
    await tester.tap(find.byType(ElevatedButton));
  });

  testWidgets('Home nav bar', (WidgetTester tester) async {
    UserInfoModel user = getMockUserInfo();

    when(mockFireStoreService.getUsers()).thenAnswer((_) async => Future.value([user]));
    when(mockFireStoreService.getCurrentUid()).thenAnswer((_) => "1");

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavNotifier(),
            ),
            Provider(create: (context) => mockFireStoreService),
          ],
          child: const MaterialApp(home: HomePageNavBar(child: AllProfilesPage())),
        )
    );
    await tester.pumpAndSettle();

    expect(find.byType(AllProfilesPage), findsOneWidget);
    expect(find.text('Kimmy'), findsOneWidget);
    expect(find.byType(HomePageNavBar), findsOneWidget);
  });

  testWidgets('Message page', (WidgetTester tester) async {

    when(mockFireStoreService.getUserNameById('0')).thenAnswer((_) async => Future.value('test'));
    when(mockFireStoreService.getUserAvatarById('1')).thenAnswer((_) async => Future.value(''));
    when(mockFireStoreService.getChatHistory('123')).thenAnswer((_) => Stream.value([MessageModel('1', 'ly', '', 'Hi', 0)]));

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavNotifier(),
            ),
            Provider(create: (context) => mockFireStoreService),
          ],
          child: const MaterialApp(
            home: MessagePage(msgId: '123', userId: '0',),
          ),
        )
    );

    await tester.pumpAndSettle();
    await tester.pump(Duration.zero);

    expect(find.byType(MessagePage), findsOneWidget);
  });

  testWidgets('Message List page', (WidgetTester tester) async {

    when(mockFireStoreService.getUserNameById('1')).thenAnswer((_) async => Future.value('test'));
    when(mockFireStoreService.getUserAvatarById('1')).thenAnswer((_) async => Future.value(''));
    when(mockFireStoreService.getAllConnections()).thenAnswer((_) => Stream.value([ConnectionModel('1', 'ly', '', '123')]));

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavNotifier(),
            ),
            Provider(create: (context) => mockFireStoreService),
          ],
          child: const MaterialApp(
            home: MessageListPage(),
          ),
        )
    );

    await tester.pumpAndSettle();
    await tester.pump(Duration.zero);

    expect(find.byType(MessageListPage), findsOneWidget);
  });

  testWidgets('Like request page', (WidgetTester tester) async {

    when(mockFireStoreService.getUserNameById('0')).thenAnswer((_) async => Future.value('test'));
    when(mockFireStoreService.getUserAvatarById('0')).thenAnswer((_) async => Future.value(''));
    when(mockFireStoreService.getLikeRequests()).thenAnswer((_) => Stream.value([getMockUserInfo()]));

    await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => NavNotifier(),
            ),
            Provider(create: (context) => mockFireStoreService),
          ],
          child: MaterialApp(
            home: const LikeRequestPage(),
            builder: EasyLoading.init(),
          ),
        )
    );

    await tester.pumpAndSettle();
    await tester.pump(Duration.zero);

    expect(find.byType(LikeRequestPage), findsOneWidget);

    when(mockFireStoreService.checkConnectionStatus('0')).thenAnswer((_) async => Future.value(false));
    await tester.tap(find.byKey(const Key('acceptBtn')));

    await tester.tap(find.byKey(const Key('rejectBtn')));
  });

  test('ConnectionModel Test', () {
    Map<String, dynamic> mockSnapshotData = {
      'id': '0',
      'name': 'John Doe',
      'avatar': '',
      'msgId': '123'
    };
    when(mockDocumentSnapshot.data()).thenAnswer((_) => mockSnapshotData);
    ConnectionModel snapConnectionInfo = ConnectionModel.fromSnapshot(mockDocumentSnapshot);
    expect(snapConnectionInfo.id, '0');
    expect(snapConnectionInfo.name, 'John Doe');
  });

  test('MessageModel Test', () {
    Map<String, dynamic> mockSnapshotData = {
      'senderId': '0',
      'senderName': 'John Doe',
      'senderAvatar': '',
      'msg': 'Hi',
      'time': 0
    };
    when(mockDocumentSnapshot.data()).thenAnswer((_) => mockSnapshotData);
    MessageModel snapMessageInfo = MessageModel.fromSnapshot(mockDocumentSnapshot);
    expect(snapMessageInfo.senderId, '0');
    expect(snapMessageInfo.senderName, 'John Doe');
  });

  testWidgets('Test main() function', (WidgetTester tester) async {
    // Build the MyApp widget
    await tester.pumpWidget(MyApp());

    // Verify that the MaterialApp is rendered
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('registration page, test validator', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
    expect(find.byType(RegistrationPage), findsOneWidget);

    // Find the button widget
    final buttonFinder = find.byType(ElevatedButton);
    // Scroll the button into view
    await tester.ensureVisible(buttonFinder);
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Nickname can not be null'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password should be at least 6 characters'), findsOneWidget);
    expect(find.text('Age can not be null'), findsOneWidget);
    expect(find.text('Intro can not be null'), findsOneWidget);
  });

  testWidgets('registration page, test togglebutton action', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RegistrationPage(),
    ));
    expect(find.byType(RegistrationPage), findsOneWidget);

    // Find the toggle buttons
    final toggleButtonsFinder = find.byType(ToggleButtons);

    // Verify that there's only one ToggleButtons widget
    expect(toggleButtonsFinder, findsOneWidget);
    await tester.ensureVisible(toggleButtonsFinder);

    // Tap the 2nd toggle button to activate it
    await tester.tap(find.text('woman'));

    // Rebuild the widget after the button tap
    await tester.pump();

    // Verify if the first toggle button is highlighted
    final toggleButtons = tester.widget<ToggleButtons>(toggleButtonsFinder);
    expect(toggleButtons.isSelected[1], true);
  });
}
