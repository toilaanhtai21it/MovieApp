import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class UpgradeAccount extends StatefulWidget {
  @override
  _UpgradeAccountState createState() => _UpgradeAccountState();
}

class _UpgradeAccountState extends State<UpgradeAccount> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 0.9),
        title: const Text('Upgrade Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Unlock Premium Features!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Upgrade to premium to access exclusive content, remove ads, and enjoy a seamless experience.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildCardInputForm(),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5, // Shadow effect for elevation
                ),
                onPressed: () async {
                  _handlePayment();
                },
                child: const Text(
                  "Pay \$9.99",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardInputForm() {
    return Column(
      children: [
        _buildTextField(
          controller: cardNumberController,
          labelText: 'Card Number',
          hintText: '1234 5678 9012 3456',
          keyboardType: TextInputType.number,
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: fullNameController,
          labelText: 'Full Name',
          keyboardType: TextInputType.text,
          icon: Icons.person,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: expiryController,
                labelText: 'MM/YY',
                hintText: '08/24',
                keyboardType: TextInputType.datetime,
                icon: Icons.calendar_today,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTextField(
                controller: cvvController,
                labelText: 'CVV',
                hintText: '123',
                keyboardType: TextInputType.number,
                obscureText: true,
                icon: Icons.lock,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  void _handlePayment() {
    final cardNumber = cardNumberController.text;
    final fullName = fullNameController.text;
    final expiry = expiryController.text;
    final cvv = cvvController.text;

    // Kiểm tra đầu vào
    if (cardNumber.isEmpty ||
        fullName.isEmpty ||
        expiry.isEmpty ||
        cvv.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Please fill in all fields"),
        ),
      );
      return;
    }

    // Giả lập kiểm tra thẻ (ví dụ kiểm tra số thẻ phải bắt đầu bằng '4')
    if (cardNumber.startsWith('4') && cardNumber.length == 16) {
      // Thẻ hợp lệ
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Payment Successful!"),
          content: const Text("You have successfully made the payment."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng thông báo
                Navigator.pushReplacementNamed(
                    context, '/HomePage'); // Chuyển về HomePage
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Thẻ không hợp lệ
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Payment Failed"),
          content: Text("Invalid card details. Please try again."),
        ),
      );
    }
  }
}
