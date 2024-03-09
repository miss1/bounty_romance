import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/db.dart';

class MessagePage extends StatelessWidget {
  final String msgId;
  final String name;
  const MessagePage({super.key, required this.msgId, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(name),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: InfoList( msgId: msgId,)),
          const InputMsg()
        ],
      ),
    );
  }
}

class InfoList extends StatelessWidget {
  final String msgId;
  const InfoList({super.key, required this.msgId});

  Widget _imageWidget(avatar) {
    if (avatar != '') {
      return Image.network(avatar, width: 60, height: 60, fit: BoxFit.cover,);
    }
    return Image.asset('assets/default.jpg', width: 60, height: 60, fit: BoxFit.cover,);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<FireStoreService>().getChatHistory(msgId),
      builder: (context, streamSnapshot) {
        if(streamSnapshot.hasData) {
          final queryResults = streamSnapshot.data!;
          if (queryResults.isEmpty) {
            return const Center(
                child: Text('No Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32,))
            );
          }
          return ListView(
            shrinkWrap: true,
            children: queryResults.map<Padding>((doc) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  ClipOval(child: _imageWidget(doc.senderAvatar),),
                  Expanded(
                    child: Card(
                      color: Colors.lightGreen,
                      elevation: 2.0,
                      margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(doc.msg),
                      )
                    ),
                  )
                ],
              ),
            )).toList(),
          );
        }
        return const Center(child: CircularProgressIndicator(),);
      }
    );
  }
}

class InputMsg extends StatefulWidget {
  const InputMsg({super.key});

  @override
  State<InputMsg> createState() => _InputMsg();
}

class _InputMsg extends State<InputMsg> {
  final msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Text('input');
  }
}