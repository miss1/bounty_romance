import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String loginErrorMsg = '';

  Future<void> loginFn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passwordController.text
      );
      setState(() {loginErrorMsg = '';});
      usernameController.clear();
      passwordController.clear();
      if (context.mounted) GoRouter.of(context).replace('/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {loginErrorMsg = 'No user found for that email.';});
      } else if (e.code == 'wrong-password') {
        setState(() {loginErrorMsg = 'Wrong password provided for that user.';});
      } else {
        setState(() {loginErrorMsg = 'Login failed';});
        await FirebaseAuth.instance.signOut();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bounty Romance'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Center(
                              child: Text('Hello!', style: Theme.of(context).textTheme.headlineMedium),
                            )
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 0.0, bottom: 25.0),
                            child: Center(
                              child: Text('Sign in to your account', style: TextStyle(fontSize: 14.0,)),
                            )
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: TextFormField(
                            key: const Key('email'),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  usernameController.clear();
                                },
                              ),
                            ),
                            controller: usernameController,
                            validator: (String? value) {
                              String emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                              RegExp regExp = RegExp(emailPattern);
                              if (value == null || value.isEmpty || !regExp.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                          child: TextFormField(
                            key: const Key('password'),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  passwordController.clear();
                                },
                              ),
                            ),
                            obscureText: true,
                            controller: passwordController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty || value.length < 6) {
                                return 'Password should be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  loginFn(context);
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 45.0),
                                ),
                              ),
                              child: const Text('Sign in', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                            ),
                          ),
                        ),

                        Center(
                          child: Text(loginErrorMsg, style: const TextStyle(fontSize: 16.0, color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ),
                //const SizedBox(height: 200),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don`t have an account? ', style: TextStyle(fontSize: 14.0)),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).go('/registration');
                            },
                            child: const Text('Sign up', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                          )
                        ]
                    )
                )
              ]
          ),
        ),
      )
    );
  }
}