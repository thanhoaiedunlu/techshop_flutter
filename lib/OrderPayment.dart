import 'package:flutter/material.dart';
import 'create_order.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderPaymentPage extends StatelessWidget {
  final double totalAmount;

  OrderPaymentPage({required this.totalAmount});

  Future<void> _payWithZaloPay(BuildContext context) async {
    try {
      final String amount = totalAmount.toStringAsFixed(0);
      final data = await CreateOrder.createOrder(amount);

      if (data['return_code'] == 1) {
        final String token = data['zp_trans_token'];
        final String deeplink = "demozpdk://app?token=$token";

        if (await canLaunch(deeplink)) {
          await launch(deeplink);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cannot open ZaloPay")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create order")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thanh Toán")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Tổng tiền: $totalAmount VND"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _payWithZaloPay(context),
              child: Text("Thanh Toán với ZaloPay"),
            ),
          ],
        ),
      ),
    );
  }
}
