import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'common/db.dart';
import 'common/data.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  final List<String> genders = ['man', 'woman', 'others'];
  final List<bool> selectedGender = <bool>[false, false, false];
  String updateErrorMsg = '';
  int genderIdx = 0;
  String avatarUrl = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserInfo();
  }

  Future<void> getCurrentUserInfo() async {
    String id = context.read<FireStoreService>().getCurrentUid();
    UserInfoModel info = await context.read<FireStoreService>().getUserInfo(id);
    setState(() {
      avatarUrl = info.avatar;
      genderIdx = info.gender;
      selectedGender[info.gender] = true;
      _nameController.text = info.name;
      _ageController.text = info.age;
      _introController.text = info.intro;
    });
  }

  Future<void> uploadAvatar() async {
    final result = await GoRouter.of(context).push('/uploadAvatar', extra: avatarUrl);
    if (result != null && result != '') {
      setState(() {
        avatarUrl = result.toString();
      });
    }
  }

  Future<void> updateUserProfile(BuildContext context) async {
    UserInfoModel newInfo = UserInfoModel(id: '', name: _nameController.text,
        email: '', age: _ageController.text, intro: _introController.text,
        gender: genderIdx, avatar: avatarUrl, city: '', lat: 0.0, lng: 0.0);
    try {
      await context.read<FireStoreService>().updateUserProfile(newInfo);
      setState(() {updateErrorMsg = '';});
      if (context.mounted) GoRouter.of(context).pop('success');
    } catch (e) {
      print(e);
      setState(() {updateErrorMsg = 'update profile failed';});
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
            GoRouter.of(context).pop();
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
                              child: Text('Edit Profile', style: Theme.of(context).textTheme.headlineMedium),
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
                                updateUserProfile(context);
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
                            child: const Text('Submit', style: TextStyle(fontSize: 16.0, color: Colors.white)),
                          ),
                        ),
                        Center(
                          child: Text(updateErrorMsg, style: const TextStyle(fontSize: 16.0, color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                )
              ]
          ),
        ),
      ),
    );
  }
}
