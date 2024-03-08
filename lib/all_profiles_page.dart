import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'common/userinfo_model.dart';
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
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    List<UserInfoModel> usersData = await context.read<FireStoreService>().getUsers();
    if (context.mounted) context.read<NavNotifier>().changeNavBar(0);
    setState(() {
      userList = usersData;
      String id = context.read<FireStoreService>().getCurrentUid();
      userList.removeWhere((item) => item.id == id);
    });
  }

  Widget _imageWidget(avatar) {
    if (avatar != '') {
      return Image.network(avatar, width: MediaQuery.of(context).size.width * 0.9, fit: BoxFit.cover,);
    }
    return Image.asset('assets/default.jpg', width: MediaQuery.of(context).size.width * 0.9, fit: BoxFit.cover,);
  }

  @override
  Widget build(BuildContext context) {
    if (userList.isEmpty) {
      return const Center(
        child: Text(
          "No user found!",
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      );
    }
    return PageView(
      controller: controller,
      children: userList.map((e) => Center(
        child: GestureDetector(
          onTap: () {
            GoRouter.of(context).push('/userProfile', extra: e.id);
          },
          child: Card(
            elevation: 3.0,
            margin: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _imageWidget(e.avatar)),
                  ),
                const SizedBox(height: 10),
                Center(
                  child: Wrap(
                    children: [
                      Text(
                        e.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        e.age,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }
}