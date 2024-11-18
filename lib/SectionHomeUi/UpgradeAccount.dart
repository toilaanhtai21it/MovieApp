import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class UpgradeAccount extends StatefulWidget {
  @override
  _UpgradeAccountState createState() => _UpgradeAccountState();
}

class _UpgradeAccountState extends State<UpgradeAccount> {
  Map<String, dynamic>? paymentIntent;

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
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Upgrade to premium to access exclusive content, remove ads, and enjoy a seamless experience.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  await makePayment();
                },
                child: const Text(
                  "Pay \$9.99",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      // 1. Tạo Payment Intent từ phía server
      paymentIntent = await createPaymentIntent('9.99', 'USD');

      // 2. Hiển thị Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Your App Name',
        ),
      );

      // 3. Hiển thị thanh toán
      await Stripe.instance.presentPaymentSheet();

      // Thành công
      setState(() {
        paymentIntent = null;
      });
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Payment Successful!"),
        ),
      );
    } catch (e) {
      print('Error during payment: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text("Payment Failed: $e"),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (double.parse(amount) * 100)
            .toString(), // Stripe yêu cầu amount ở dạng cent
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51QM8IxRwwGPjVJO28UA2LWiSN4v7KV2KpYIkLYGS7dlp7aTq12WrQukJ16L2oIQmDYk7922LmT9SG79RQckYXhKe000LvGFk7k',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
