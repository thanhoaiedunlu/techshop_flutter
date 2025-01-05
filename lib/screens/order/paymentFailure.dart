import 'package:flutter/material.dart';

import '../../routes/routes.dart';

class PaymentFailureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red, // Đổi màu biểu tượng thành đỏ
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Thanh toán thất bại',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Rất tiếc, giao dịch của quý khách đã không thành công. '
                    'Vui lòng kiểm tra thông tin và thử lại.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.home);
// Quay lại trang chủ
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Màu nền nút (màu đỏ)
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Quay về trang chủ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}