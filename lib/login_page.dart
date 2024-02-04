import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'registration_page.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String loginErrorMsg = '';

  void loginFn() {
    if(_formKey.currentState?.validate() ?? false) {
      attemptLogin();
      _formKey.currentState!.reset();
    }
  }

  void signupFn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
  }

  void attemptLogin() {
    // this where you call the api from Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
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
                  TextFormField(
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
                  const SizedBox(height: 20),
                  TextFormField(
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
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // registerUser(_emailController.text, _passwordController.text);
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
                  Center(
                    child: Text(loginErrorMsg, style: const TextStyle(fontSize: 16.0, color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don`t have an account? ', style: TextStyle(fontSize: 14.0)),
                  GestureDetector(
                    onTap: () {
                      signupFn();
                    },
                    child: const Text('Sign up', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                  )
                ]
            )
          )
        ]
      ),
    );
  }
}