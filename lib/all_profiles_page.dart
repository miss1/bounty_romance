import 'package:flutter/material.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3,
          margin: const EdgeInsets.all(8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/default.jpg', width: 250, height: 250),
              ),
              Text(userList[index].name, style: const TextStyle(fontSize: 18)),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    isSelected: filledSelected,
                    icon: const Icon(Icons.favorite_border, color: Colors.pink,),
                    selectedIcon: const Icon(Icons.favorite, color: Colors.pink,),
                    onPressed: () {
                      print("send like request");
                      setState(() {
                        filledSelected = !filledSelected;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}