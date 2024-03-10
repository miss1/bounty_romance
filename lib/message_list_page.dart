import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'common/db.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LikesPanel(),
        SizedBox(height: 5,),
        Expanded(child: MessageList())
      ],
    );
  }
}

class LikesPanel extends StatelessWidget {
  const LikesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/likeRequest');
      },
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 5,),
                Text('New Likes'),
              ],
            ),
            Icon(Icons.arrow_forward),
          ],
        )
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  const MessageList({super.key});

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
    return Material(
      child: StreamBuilder(
        stream: context.read<FireStoreService>().getAllConnections(),
        builder: (context, streamSnapshot) {
          if(streamSnapshot.hasData) {
            final queryResults = streamSnapshot.data!;
            if (queryResults.isEmpty) {
              return const Center(
                  child: Text('No friends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32,))
              );
            }
            return ListView(
              children: queryResults.map<ListTile>((doc) => ListTile(
                leading: ClipOval(child: _imageWidget(context, doc.id),),
                title: _nameWidget(context, doc.id),
                trailing: const Icon(Icons.keyboard_arrow_right),
                contentPadding: const EdgeInsets.all(10),
                onTap: () {
                  print('message id: ${doc.msgId}; user id: ${doc.id}');
                  GoRouter.of(context).push(
                      Uri(
                          path: '/chat',
                          queryParameters: {'msgId': doc.msgId, 'uid': doc.id}
                      ).toString()
                  );
                },
              )).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}