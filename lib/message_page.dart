import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/db.dart';
import 'common/nav_notifier.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

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

  Widget _imageWidget(avatar) {
    if (avatar != '') {
      return Image.network(avatar, width: 60, height: 60, fit: BoxFit.cover,);
    }
    return Image.asset('assets/default.jpg', width: 60, height: 60, fit: BoxFit.cover,);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
            shrinkWrap: true,
            children: queryResults.map<ListTile>((doc) => ListTile(
              leading: _imageWidget(doc.avatar),
              title: Text(doc.name),
            )).toList(),
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      }
    );
  }
}