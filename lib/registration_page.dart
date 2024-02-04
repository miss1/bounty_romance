import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bounty Romance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Registration(title: 'Bounty Romance'),
    );
  }
}

class Registration extends StatefulWidget {
  const Registration({super.key, required this.title});

  final String title;

  @override
  State<Registration> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMsg = "";

  Future<void> registerUser(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User created: ${userCredential.user!.uid}');
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
      print('Error creating user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pop(
              context,
            );
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
              controller: _emailController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
              controller: _passwordController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print(_emailController.text);
                    print(_passwordController.text);
                    registerUser(_emailController.text, _passwordController.text);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            if (errorMsg != "")
              Text(errorMsg, style: const TextStyle(color: Colors.red, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
