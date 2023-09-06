import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/widgets/change_password.dart';
import 'package:movies/widgets/profile_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final ImagePicker _picker = ImagePicker();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  String name = '';
  String surname = '';
  String imgUrl = '';

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _signOut() async {
    FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('name') &&
          prefs.containsKey('surname') &&
          prefs.containsKey('imgUrl')) {
        setState(() {
          name = prefs.getString('name') ?? '';
          surname = prefs.getString('surname') ?? '';
          imgUrl = prefs.getString('imgUrl') ?? '';
        });
      } else {
        CollectionReference usersCollection = firestore.collection('users');

        QuerySnapshot emailQuery = await usersCollection
            .where(
              'email',
              isEqualTo: user.email,
            )
            .get();

        if (emailQuery.docs.isNotEmpty) {
          Map<String, dynamic> userData =
              emailQuery.docs.first.data() as Map<String, dynamic>;

          setState(() {
            name = userData['name'];
            surname = userData['surname'];
          });

          prefs.setString('name', name);
          prefs.setString('surname', surname);
        }

        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(user.uid);

        final downloadUrl = await storageReference.getDownloadURL();

        if (downloadUrl.isNotEmpty) {
          setState(() {
            imgUrl = downloadUrl;
          });
          prefs.setString('imgUrl', imgUrl);
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  void _chooseFromLibrary() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        final Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(user.uid);

        final UploadTask uploadTask = storageReference.putFile(imageFile);
        final TaskSnapshot taskSnapshot = await uploadTask;

        if (taskSnapshot.state == TaskState.success) {
          final downloadUrl = await taskSnapshot.ref.getDownloadURL();
          setState(() {
            imgUrl = downloadUrl;
          });
        } else {
          return null;
        }
      } else {
        print('Image picker canceled');
      }
    } catch (e) {}
  }

  void _openChangePassword() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => ChangePassword(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    image: DecorationImage(
                      image: NetworkImage(imgUrl),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.dstATop),
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  child: GestureDetector(
                    onTap: _chooseFromLibrary,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(75),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: imgUrl.isNotEmpty
                            ? Image(
                                image: NetworkImage(imgUrl),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/default_user.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  ProfileItem(title: 'Name', value: name),
                  ProfileItem(title: 'Surname', value: surname),
                  ProfileItem(title: 'Email', value: user.email!),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton.icon(
                      onPressed: _openChangePassword,
                      icon: const Icon(Icons.change_circle),
                      label: const Text('Change Password'),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Log out'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
