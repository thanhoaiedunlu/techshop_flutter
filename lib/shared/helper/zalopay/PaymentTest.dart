import 'package:flutter/material.dart';

import 'CreateOrder.dart';
import 'ZaloPayService.dart';


class PaymentTestPage extends StatefulWidget {
  @override
  _PaymentTestPageState createState() => _PaymentTestPageState();
}

class _PaymentTestPageState extends State<PaymentTestPage> {
  String _paymentStatus = "Chưa thanh toán";

  Future<void> _handlePayment() async {

    try {
      // Khởi tạo đơn hàng
      final data = await CreateOrder.createOrder("100000");
      if (data['return_code'] == 1) {
        String token = data['zp_trans_token'];

        // Gọi thanh toán


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Khởi tạo đơn hàng thành công, đang mở ZaloPay...")),
        );
        debugPrint("Thông báo quan trọng");
        final result = await ZaloPayService.payOrder(token);
        debugPrint("Kết quả từ payOrder: $result");


        print("result: %result");

        setState(() {
          _paymentStatus = result;
        });
      } else {
        setState(() {
          _paymentStatus = "Lỗi khi khởi tạo đơn hàng: ${data['return_message']}";
        });
      }
    } catch (e) {
      setState(() {
        _paymentStatus = "Lỗi thanh toán: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test ZaloPay Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trạng thái thanh toán:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _paymentStatus,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handlePayment,
              child: Text("Thanh toán với ZaloPay"),
            ),
          ],
        ),
      ),
    );
  }
}
