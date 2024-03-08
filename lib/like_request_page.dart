import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/db.dart';

class LikeRequestPage extends StatelessWidget {
  const LikeRequestPage({super.key});

  Widget _imageWidget(avatar) {
    if (avatar != '') {
      return Image.network(avatar, width: 60, height: 60, fit: BoxFit.cover,);
    }
    return Image.asset('assets/default.jpg', width: 60, height: 60, fit: BoxFit.cover,);
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
                  leading: _imageWidget(doc.avatar),
                  title: Text(doc.name),
                  subtitle: const Text('Wants to connect', style: TextStyle(color: Colors.red),),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print('Accept');
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),),
                        ),
                        child: const Text('Accept', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 5,),
                      ElevatedButton(
                        onPressed: () {
                          print('Reject');
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