import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageList();
}

class _MessageList extends State<MessageList> {
  @override
  void initState() {
    super.initState();
    // if (context.mounted) context.read<NavNotifier>().changeNavBar(1);
  }

  @override
  Widget build(BuildContext context) {
    return Text('Message');
  }
}