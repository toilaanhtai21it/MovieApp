import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EditProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _fullname = '';
  String _dob = '';
  String _email = '';
  String? _profileImagePath; // Lưu đường dẫn cục bộ của ảnh

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      // Lấy dữ liệu từ Firestore
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc('user_id'); // Thay 'user_id' bằng logic phù hợp
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        setState(() {
          _username = data?['username'] ?? '';
          _fullname = data?['fullname'] ?? '';
          _dob = data?['dob'] ?? '';
          _email = data?['email'] ?? '';
          _profileImagePath =
              data?['profileImagePath']; // Lấy đường dẫn ảnh cục bộ
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Widget _buildProfileInfo(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              if (result == true) {
                // Nếu EditProfile trả về true
                _loadProfile(); // Làm mới dữ liệu
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImagePath != null
                    ? FileImage(File(
                        _profileImagePath!)) // Dùng FileImage với đường dẫn cục bộ
                    : const AssetImage('assets/user.png') as ImageProvider,
                backgroundColor: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileInfo('Username', _username),
            _buildProfileInfo('Full Name', _fullname),
            _buildProfileInfo('Date of Birth', _dob),
            _buildProfileInfo('Email', _email),
          ],
        ),
      ),
    );
  }
}
