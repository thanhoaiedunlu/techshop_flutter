import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditCustomerScreen extends StatefulWidget {
  final String customerId;
  final String customerUsername;
  final String customerEmail;
  final String customerPhone;

  EditCustomerScreen({
    required this.customerId,
    required this.customerUsername,
    required this.customerEmail,
    required this.customerPhone,
  });

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.customerUsername);
    _emailController = TextEditingController(text: widget.customerEmail);
    _phoneController = TextEditingController(text: widget.customerPhone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh Sửa Khách Hàng"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Thêm logic cập nhật khách hàng tại đây
              },
              child: Text('Cập Nhật'),
            ),
          ],
        ),
      ),
    );
  }
}