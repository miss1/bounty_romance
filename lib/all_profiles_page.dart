import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'common/db.dart';

class AllProfilesPage extends StatefulWidget {
  const AllProfilesPage({super.key});

  @override
  State<AllProfilesPage> createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfilesPage> {
  List<Map<String, dynamic>> userList = [];
  bool filledSelected = false;

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    List<Map<String, dynamic>> usersData = await FireStoreService.getUsers();
    setState(() {
      userList = usersData;
    });
  }

  Future<void> logoutFn(context) async {
    await FirebaseAuth.instance.signOut();
    GoRouter.of(context).replace('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bounty Romance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              logoutFn(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
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
                  Text(userList[index]['name'], style: const TextStyle(fontSize: 18)),
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
      ),
    );
  }
}