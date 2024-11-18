import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import './UpgradeAccount.dart';
import './ProfilePage.dart';
import './../login_register.dart'; // Import màn hình đăng nhập/đăng ký
import './AIScreenChat.dart'; // Import màn hình trò chuyện với AI
import './../SectionHomeUi/FavoriateList.dart';
import './../HomePage/HomePage.dart';
import 'EditProfile.dart';
import 'ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class drawerfunc extends StatefulWidget {
  @override
  State<drawerfunc> createState() => _drawerfuncState();
}

class _drawerfuncState extends State<drawerfunc> {
  File? _image;
  String _fullname = "Full Name"; // Giá trị mặc định
  String _username = "Anh Tai"; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      // Lấy dữ liệu từ Firestore
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc('user_id'); // Thay 'user_id' bằng logic phù hợp
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        setState(() {
          String? imagePath = data?['profileImagePath'];
          if (imagePath != null) {
            _image = File(imagePath); // Lưu đường dẫn ảnh cục bộ
          }
          _fullname = data?['fullname'] ?? 'Full Name';
          _username = data?['username'] ?? 'Anh Tai';
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );
      if (croppedFile != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('imagepath', croppedFile.path);
        setState(() {
          _image = File(croppedFile.path);
        });
        Fluttertoast.showToast(
          msg: "Image Changed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa toàn bộ thông tin lưu trữ để đăng xuất
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginRegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(18, 18, 18, 0.9),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _selectImage();
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image == null
                          ? AssetImage('assets/user.png') as ImageProvider
                          : FileImage(_image!),
                      backgroundColor: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _fullname, // Hiển thị full name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            listtilefunc('Home', Icons.home, ontap: () {
              Navigator.pop(context);
            }),
            listtilefunc('Favorite', Icons.favorite, ontap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FavoriateMovies()));
            }),
            listtilefunc('Upgrade Account', Icons.credit_card, ontap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UpgradeAccount()));
            }),
            listtilefunc('Profile', Icons.person, ontap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              _loadProfileData(); // Reload profile data after returning
            }),
            listtilefunc('AI Chat', Icons.chat, ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AIChatScreen()),
              );
            }),
            listtilefunc('About', Icons.info, ontap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(18, 18, 18, 0.9),
                    title: Text(
                      'This App is made by Anh Tai. User can explore, get details of the latest Movies/Series. TMDB API is used to fetch data.',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      )
                    ],
                  );
                },
              );
            }),
            listtilefunc('Logout', Icons.exit_to_app, ontap: () {
              _logout();
            }),
          ],
        ),
      ),
    );
  }
}

Widget listtilefunc(String title, IconData icon, {Function? ontap}) {
  return GestureDetector(
    onTap: ontap as void Function()?,
    child: ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
