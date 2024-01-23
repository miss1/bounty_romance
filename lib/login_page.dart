import 'package:flutter/material.dart';
import './registration_page.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? loginInput;
  String? pwInput;

  void loginFn() {
    setState(() {
      loginInput = usernameController.text;
      pwInput = passwordController.text;
    });
    attemptLogin();
  }

  void signupFn() {
    // call api here
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // username area
                Text(
                    'username', style: Theme.of(context).textTheme.headlineMedium
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your username here',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // clear the text box
                          usernameController.clear();
                        },
                      ),
                    ),
                  ),
                ),

                // add 20px spacing
                SizedBox(
                  height: 20,
                ),

                // password area
                Text(
                    'password', style: Theme.of(context).textTheme.headlineMedium
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child:
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your password here',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // clear the text box
                          passwordController.clear();
                        },
                      ),
                    ),
                  ),
                ),

                // add 20px spacing
                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),

                    // this is the login button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)
                        ),
                        fixedSize: const Size(150, 20),
                      ),
                      onPressed: loginFn,
                      child: const Text(
                        "login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    // this is the signup button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        fixedSize: const Size(150, 20),
                      ),
                      onPressed: signupFn,
                      child: const Text(
                        "sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}