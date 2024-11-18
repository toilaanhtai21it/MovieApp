import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> updateUserProfile({
    required String username,
    required String fullname,
    required String dob,
    required String email,
    String? profileImagePath,
  }) async {
    try {
      // Xác định ID tài liệu để lưu thông tin (cố định hoặc cung cấp từ tham số)
      const String userId = "default_user_id"; // ID cố định hoặc tuỳ chỉnh.

      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'fullname': fullname,
        'dob': dob,
        'email': email,
        'profileImagePath': profileImagePath,
      });
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      const String userId = "default_user_id"; // Sử dụng cùng ID tài liệu.

      final snapshot = await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.data();
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
    return null;
  }
}
