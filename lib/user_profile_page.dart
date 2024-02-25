import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'common/data.dart';
import 'common/db.dart';
import 'common/nav_notifier.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  UserInfoModel userInfo = UserInfoModel.generateEmpty();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    String uid = FireStoreService.getCurrentUid();
    UserInfoModel info = await FireStoreService.getUserInfo(uid);
    if (context.mounted) context.read<NavNotifier>().changeNavBar(1);
    debugPrint(info.id);
    setState(() {
      userInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(userInfo.name);
  }
}