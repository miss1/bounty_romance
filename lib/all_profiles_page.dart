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
    final double width = MediaQuery.of(context).size.width; //to get the width of screen
    final double height = MediaQuery.of(context).size.height; //to get height of screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: height * 0.45,
                child: Stack(
                  children: [
                    Positioned(
                        child: Material(
                          child: Container(
                            height: height*0.4,
                            width: width*0.95,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(0.0),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow//BoxShadow
                              ],
                            ),
                          ),

                        )
                    ),
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