import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'db.dart';

class AllProfilesPage extends StatelessWidget {
  const AllProfilesPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounty Romance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AllProfiles(title: 'Welcome!'),
    );
  }
}

class AllProfiles extends StatefulWidget {
  const AllProfiles({super.key, required this.title});

  final String title;

  @override
  State<AllProfiles> createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfiles> {
  List<Map<String, dynamic>> userList = [];

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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(title: 'Bounty Romance')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          print("send like request");
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