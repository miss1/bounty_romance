import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'common/db.dart';
import 'common/data.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  final List<String> genders = ['man', 'woman', 'others'];
  final List<bool> selectedGender = <bool>[true, false, false];
  String registerErrorMsg = '';
  int genderIdx = 0;
  String avatarUrl = '';

  void navigateToLogin(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).replace('/');
    }
  }

  Future<void> registerUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      UserInfoModel userInfo = UserInfoModel(
          id: userCredential.user!.uid,
          name: _nameController.text,
          email: _emailController.text,
          age: _ageController.text,
          intro: _introController.text,
          gender: genderIdx,
          avatar: avatarUrl,
          city: '-',
          lat: 0.0,
          lng: 0.0
      );
      if (context.mounted) await context.read<FireStoreService>().createUser(userInfo);

      setState(() {registerErrorMsg = '';});
      _emailController.clear();
      _passwordController.clear();
      if (context.mounted) navigateToLogin(context);
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

  Future<void> uploadAvatar() async {
    final result = await GoRouter.of(context).push('/uploadAvatar', extra: avatarUrl);
    if (result != null && result != '') {
      setState(() {
        avatarUrl = result.toString();
      });
    }
  }

  Widget _imageWidget() {
    if (avatarUrl == '') {
      return Image.asset('assets/default.jpg', width: 150, height: 150);
    } else {
      return Image.network(avatarUrl, width: 150, height: 150);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Bounty Romance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigateToLogin(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
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
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Center(
                              child: Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
                            )
                        ),
                        const SizedBox(height: 20),
                        // upload image
                        Center(
                          child: GestureDetector(
                              onTap: () {
                                uploadAvatar();
                              },
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: _imageWidget()
                                  ),
                                  const Icon(Icons.edit)
                                ],
                              )
                          ),
                        ),
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 20),

                        // age input
                        TextFormField(
                          key: const Key('ageTextInput'),
                          decoration: InputDecoration(
                            hintText: 'Enter your age',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _ageController.clear();
                              },
                            ),
                          ),
                          controller: _ageController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Age can not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // intro input
                        TextFormField(
                          key: const Key('introTextInput'),
                          decoration: InputDecoration(
                            hintText: 'Enter your intro',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _introController.clear();
                              },
                            ),
                          ),
                          controller: _introController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Intro can not be null';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // gender input
                        Center(
                          child: ToggleButtons(
                            direction: Axis.horizontal,
                            constraints: const BoxConstraints(
                              minHeight: 40.0,
                              minWidth: 80.0,
                            ),
                            fillColor: Colors.green,
                            selectedBorderColor: Colors.black87,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            isSelected: selectedGender,
                            onPressed: (int index) {
                              setState(() {
                                genderIdx = index; // update the state
                                print('selected gender idx = $genderIdx');
                                // The button that is tapped is set to true, and the others to false.
                                for (int i = 0; i < selectedGender.length; i++) {
                                  if (i == index) {
                                    selectedGender[i] = true;
                                  } else {
                                    selectedGender[i] = false;
                                  }
                                }
                              });
                            },
                            children: const [
                              Text('man'),
                              Text('woman'),
                              Text('others'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                registerUser(context);
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
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ', style: TextStyle(fontSize: 14.0)),
                          GestureDetector(
                            onTap: () {
                              navigateToLogin(context);
                            },
                            child: const Text('Sign in', style: TextStyle(fontSize: 14.0, color: Colors.blue)),
                          )
                        ]
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}
