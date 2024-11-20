import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'userdetailpage.dart';

class ProfileAdminPage extends StatefulWidget {
  @override
  _ProfileAdminPageState createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<User>? _users;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    // Firebase Authentication không cung cấp API trực tiếp để lấy danh sách user.
    // Thay vào đó, bạn cần tích hợp Admin SDK qua backend.
    // Dưới đây là minh họa tạm thời để kiểm tra user hiện tại:
    setState(() {
      _users = _auth.currentUser != null ? [_auth.currentUser!] : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý người dùng'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: _users == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users!.length,
              itemBuilder: (context, index) {
                final user = _users![index];
                return ListTile(
                  title: Text(
                    user.email ?? 'Không rõ',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserDetailPage(uid: user.uid), // Truyền UID
                        ),
                      );
                    },
                    child: Text(
                      'UID: ${user.uid}',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _deleteUser(user.uid);
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _deleteUser(String uid) async {
    // Admin SDK cần tích hợp qua backend để thực hiện xóa user.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chức năng xóa người dùng cần Backend hỗ trợ.')),
    );
  }
}
