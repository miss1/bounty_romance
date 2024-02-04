import 'package:flutter/material.dart';

class AllProfilesPage extends StatefulWidget {
  const AllProfilesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllProfilesPageState();
  }
}

class _AllProfilesPageState extends State<AllProfilesPage> {
  // some data structure to hold the user profile data from firebase
  List<String> allProfiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 230,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: const DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/brad-pitt-attends-the-premiere-of-20th-century-foxs--square.jpg"),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}