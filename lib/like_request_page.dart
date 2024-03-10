import 'dart:async';


import 'package:bounty_romance/common/userinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/db.dart';

class LikeRequestPage extends StatelessWidget {
  const LikeRequestPage({super.key});

  Future<void> deleteOneRequest(BuildContext context, String id) async {
    try {
      EasyLoading.show(status: 'loading...');
      await context.read<FireStoreService>().deleteLikeRequest(id);
      EasyLoading.showSuccess('Reject the Request successfully');
    } catch (e) {
      EasyLoading.showError('Failed with Error');
    }
  }

  Future<void> acceptOneRequest(BuildContext context, UserInfoModel user) async {
    try {
      EasyLoading.show(status: 'loading...');
      bool isAlreadyConnect = await context.read<FireStoreService>().checkConnectionStatus(user.id);
      if (!isAlreadyConnect) {
        if (context.mounted) await context.read<FireStoreService>().addConnection(user);
      }
      if (context.mounted) await context.read<FireStoreService>().deleteLikeRequest(user.id);
      EasyLoading.showSuccess('Accept the Request successfully');
    } catch (e) {
      EasyLoading.showError('Failed with Error');
    }
  }

  // Future<String> getUserNameById(BuildContext context, String id) async {
  //   String name = await context.read<FireStoreService>().getUserNameById(id);
  //   return name;
  // }
  //
  // Future<String> getUserAvatarById(BuildContext context, String id) async {
  //   String avatar = await context.read<FireStoreService>().getUserAvatarById(id);
  //   return avatar;
  // }

  Widget _imageWidget(BuildContext context, String id) {
    return FutureBuilder<String?>(
      future: context.read<FireStoreService>().getUserAvatarById(id),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is being fetched, display a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs, display an error message
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // If the data is available
          String avatar = snapshot.data!;
          if (avatar != '') {
            return Image.network(avatar, width: 60, height: 60, fit: BoxFit.cover,);
          }
          return Image.asset('assets/default.jpg', width: 60, height: 60, fit: BoxFit.cover,);
        } else {
          // If no data is available, display an empty text widget
          return Image.asset('assets/default.jpg', width: 60, height: 60, fit: BoxFit.cover,);
        }
      },
    );
  }

  Widget _nameWidget(BuildContext context, String id) {
    return FutureBuilder<String?>(
      future: context.read<FireStoreService>().getUserNameById(id),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the data is being fetched, display a loading indicator
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs, display an error message
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // If the data is available, display the user name
          return Text(snapshot.data!);
        } else {
          // If no data is available, display an empty text widget
          return const Text('');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('New Likes'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
        body: StreamBuilder(
          stream: context.read<FireStoreService>().getLikeRequests(),
          builder: (context, streamSnapshot) {
            if(streamSnapshot.hasData) {
              final queryResults = streamSnapshot.data!;
              if (queryResults.isEmpty) {
                return const Center(
                  child: Text('No new Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32,))
                );
              }
              return ListView(
                shrinkWrap: true,
                children: queryResults.map<ListTile>((doc) => ListTile(
                  leading: _imageWidget(context, doc.id),
                  //title: Text(doc.name),
                    title: _nameWidget(context, doc.id),
                  subtitle: const Text('Wants to connect', style: TextStyle(color: Colors.red),),
                  trailing: Wrap(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          acceptOneRequest(context, doc);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),),
                        ),
                        child: const Text('Accept', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        onPressed: () async {
                          deleteOneRequest(context, doc.id);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),),
                        ),
                        child: const Text('Reject', style: TextStyle(color: Colors.white),),
                      )
                    ],
                  )
                )).toList(),
              );
            }
            return const CircularProgressIndicator();
          },
        )
    );
  }
}