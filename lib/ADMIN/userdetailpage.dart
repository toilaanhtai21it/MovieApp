import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edituserpage.dart';

class UserDetailPage extends StatefulWidget {
  final String uid; // Nhận UID từ màn hình trước

  UserDetailPage({required this.uid});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });
      }
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin người dùng'),
        backgroundColor: Colors.amber,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UID: ${widget.uid}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${userData?['email'] ?? 'Không rõ'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tên: ${userData?['fullname'] ?? 'Không rõ'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ngày sinh: ${userData?['dob'] ?? 'Không rõ'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserPage(
                                uid: widget.uid,
                                currentData: userData!,
                              ),
                            ),
                          ).then((value) {
                            if (value == true)
                              _fetchUserData(); // Cập nhật dữ liệu
                          });
                        },
                        child: Text('Chỉnh sửa'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _deleteUser(),
                        child: Text('Xóa'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Future<void> _deleteUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .delete();
      Navigator.pop(context); // Quay lại trang trước sau khi xóa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Người dùng đã được xóa.')),
      );
    } catch (e) {
      print('Lỗi khi xóa người dùng: $e');
    }
  }
}
