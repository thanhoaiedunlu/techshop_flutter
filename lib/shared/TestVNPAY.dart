import 'package:flutter/material.dart';
import 'package:techshop_flutter/shared/services/ZaloPay.dart';

class PaymentPage extends StatelessWidget {
  final String zpTransToken = 'your_transaction_token';

  void _payWithZaloPay(BuildContext context) async {
    final result = await ZaloPay.payOrder(zpTransToken);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Status: ${result['status']}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ZaloPay Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _payWithZaloPay(context),
          child: Text('Pay with ZaloPay'),
        ),
      ),
    );
  }
}
void main() => runApp(MaterialApp(
  home: PaymentPage(),
));
