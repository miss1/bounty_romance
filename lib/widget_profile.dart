import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/data.dart';
import 'common/db.dart';
import 'common/nav_notifier.dart';

class UserProfile extends StatefulWidget {
  final String pageType;
  final String uid;
  const UserProfile({super.key, required this.pageType, required this.uid});

  @override
  State<UserProfile> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  UserInfoModel userInfo = UserInfoModel.generateEmpty();

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    String id = widget.uid;
    if (id == '') {
      id = FireStoreService.getCurrentUid();
    }
    UserInfoModel info = await FireStoreService.getUserInfo(id);
    if (widget.uid == '' && context.mounted) context.read<NavNotifier>().changeNavBar(1);
    setState(() {
      userInfo = info;
    });
  }

  Widget _imageWidget(avatar) {
    if (avatar != '') {
      return Image.network(avatar, width: 200, height: 200, fit: BoxFit.cover,);
    }
    return Image.asset('assets/default.jpg', width: 200, height: 200, fit: BoxFit.cover,);
  }

  Widget _actionWidget() {
    Widget btnText;
    if (widget.pageType == 'me') {
      btnText = const Text('Edit', style: TextStyle(fontSize: 16.0, color: Colors.white));
    } else {
      btnText = const Text('Like', style: TextStyle(fontSize: 16.0, color: Colors.white));
    }
    return ElevatedButton(
      onPressed: () {
        print(widget.pageType);
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 15.0, horizontal: 45.0),
        ),
      ),
      child: btnText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              elevation: 3.0,
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  ClipOval(
                    child: _imageWidget(userInfo.avatar),
                  ),
                  const SizedBox(height: 10),
                  Text(userInfo.name, style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text('${userInfo.age} | ${userInfo.gender}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text(userInfo.email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Card(
              elevation: 3.0,
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  const Text('About me', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 15),
                  Text(userInfo.intro, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: _actionWidget(),
          )
        ],
      ),
    );
  }
}