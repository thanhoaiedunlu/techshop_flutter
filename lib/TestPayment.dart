import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'create_order.dart';

class TestPaymentPage extends StatefulWidget {
  @override
  _TestPaymentPageState createState() => _TestPaymentPageState();
}

class _TestPaymentPageState extends State<TestPaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  String _paymentStatus = "Chưa thanh toán";

  Future<void> _handlePayment() async {
    try {
      String amount = _amountController.text.trim();

      if (amount.isEmpty || double.tryParse(amount) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vui lòng nhập số tiền hợp lệ!")),
        );
        return;
      }

      // Gọi phương thức tạo đơn hàng
      final data = await CreateOrder.createOrder(amount);

      // Kiểm tra phản hồi từ ZaloPay API
      if (data['return_code'] == 1) {
        String token = data['zp_trans_token'];
        String deeplink = "demozpdk://app?token=$token";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Khởi tạo đơn hàng thành công, đang mở ZaloPay...")),
        );

        // Mở ứng dụng ZaloPay bằng deeplink
        if (await canLaunch(deeplink)) {
          await launch(deeplink);
          setState(() {
            _paymentStatus = "Đang chờ kết quả thanh toán...";
          });
        } else {
          setState(() {
            _paymentStatus = "Không thể mở ứng dụng ZaloPay!";
          });
        }
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
        title: Text("ZaloPay Test Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nhập số tiền để thanh toán:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nhập số tiền (VNĐ)",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handlePayment,
              child: Text("Thanh toán"),
            ),
            SizedBox(height: 20),
            Text(
              "Trạng thái thanh toán:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              _paymentStatus,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
