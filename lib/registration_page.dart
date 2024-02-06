import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'db.dart';
import 'package:email_validator/email_validator.dart';

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
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String registerErrorMsg = '';

  void navigateToLogin() {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop(context);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(title: 'Bounty Romance')));
    }
  }

  Future<void> registerUser(String email, String password, String name) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = <String, dynamic>{
        "id": userCredential.user!.uid,
        "name": name,
        "email": email
      };
      await FireStoreService.createUser(user);

      setState(() {registerErrorMsg = '';});
      _emailController.clear();
      _passwordController.clear();
      navigateToLogin();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {registerErrorMsg = 'The password provided is too weak.';});
      } else if (e.code == 'email-already-in-use') {
        setState(() {registerErrorMsg = 'The account already exists for that email.';});
      }
    } catch (e) {
      print(e);
      setState(() {registerErrorMsg = 'Registration failed';});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateToLogin();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
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
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
                      )
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('nickname'),
                    decoration: InputDecoration(
                      hintText: 'Enter your nickname',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _nameController.clear();
                        },
                      ),
                    ),
                    controller: _nameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Nickname can not be null';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('email'),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _emailController.clear();
                        },
                      ),
                    ),
                    controller: _emailController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const Key('password'),
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _passwordController.clear();
                        },
                      ),
                    ),
                    obscureText: true,
                    controller: _passwordController,
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
                          registerUser(_emailController.text, _passwordController.text, _nameController.text);
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
                      child: const Text('Sign up', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    ),
                  ),
                  Center(
                    child: Text(registerErrorMsg, style: const TextStyle(fontSize: 16.0, color: Colors.red)),
                  )
                ],
              ),
            ),
          ),
          Container(
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? ', style: TextStyle(fontSize: 14.0)),
                    GestureDetector(
                      onTap: () {
                        navigateToLogin();
                      },
                      child: const Text('Sign in', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                    )
                  ]
              )
          )
        ]
      )
    );
  }
}
