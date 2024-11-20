import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserPage extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> currentData;

  EditUserPage({required this.uid, required this.currentData});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _fullnameController =
        TextEditingController(text: widget.currentData['fullname'] ?? '');
    _dobController =
        TextEditingController(text: widget.currentData['dob'] ?? '');
  }

  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .update({
          'fullname': _fullnameController.text.trim(),
          'dob': _dobController.text.trim(),
        });
        Navigator.pop(context, true); // Quay lại với kết quả thành công
      } catch (e) {
        print('Lỗi khi cập nhật dữ liệu: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fullnameController,
                decoration: InputDecoration(
                  labelText: 'Họ và Tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngày sinh';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text('Lưu'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
