import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'common/data.dart';
import 'common/db.dart';
import 'common/nav_notifier.dart';

class AllProfilesPage extends StatefulWidget {
  const AllProfilesPage({super.key});

  @override
  State<AllProfilesPage> createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfilesPage> {
  List<UserInfoModel> userList = [];
  bool filledSelected = false;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    List<UserInfoModel> usersData = await FireStoreService.getUsers();
    if (context.mounted) context.read<NavNotifier>().changeNavBar(0);
    setState(() {
      userList = usersData;
      String id = FireStoreService.getCurrentUid();
      userList.removeWhere((item) => item.id == id);
    });
    print(userList);
  }

  Widget _imageWidget(avatar) {
    if (avatar != '') {
      return Image.network(avatar);
    }
    return Image.asset('assets/default.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: _imageWidget(userList[index].avatar),
              title: Text(userList[index].name),
              subtitle: Text(userList[index].intro),
              onTap: () {
                GoRouter.of(context).push('/userProfile', extra: userList[index].id);
              },
            );
          }
      ),
    );
  }
}