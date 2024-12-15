import 'package:flutter/material.dart';
import 'package:techshop_flutter/screens/home/home.dart';
import 'package:techshop_flutter/shared/services/customer/customerService.dart';
import '../../models/Customer.dart';
import '../../shared/ultis/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final customerServices = CustomerService();
  final _formKey = GlobalKey<FormState>(); // Khai báo GlobalKey cho Form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6495ED)),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Sử dụng _formKey để quản lý trạng thái form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'User name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)), // Bo tròn góc
                  ),
                  prefixIcon: Icon(Icons.account_circle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(20.0)), // Bo tròn góc
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null; // Nếu không có lỗi, trả về null
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    checkLogin();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6495ED),
                  foregroundColor: Colors.white,
                  // Chữ màu trắng
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  // Tăng chiều cao nút
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ), // Kiểu chữ
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> checkLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final customer = await customerServices.checkLogin(
      username: username,
      password: password,
    );
    if (customer != null) {
      await SharedPreferencesHelper.saveUserData(customer);
      // Hiển thị SnackBar
      Customer? savedCustomer = await SharedPreferencesHelper.getUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${savedCustomer?.phone}!')),
      );
      // Đợi một khoảng thời gian để SnackBar hiển thị xong
      Future.delayed(const Duration(seconds: 2), () {
        // Điều hướng đến màn hình Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    } else {
      // Nếu không có customer, bạn có thể hiển thị lỗi hoặc thực hiện hành động khác.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
  }

}

