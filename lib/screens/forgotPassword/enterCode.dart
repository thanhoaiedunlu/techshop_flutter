import 'package:flutter/material.dart';
import '../../shared/services/forgotPassword/PasswordResetService.dart';

class EnterCode extends StatefulWidget {
  final String username; // Nhận username từ màn hình trước

  const EnterCode({super.key, required this.username});

  @override
  State<EnterCode> createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  final PasswordResetService _service = PasswordResetService();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submitResetPassword() async {
    final resetCode = _codeController.text.trim();
    final newPassword = _passwordController.text.trim();

    if (resetCode.isNotEmpty && newPassword.isNotEmpty) {
      bool success = await _service.resetPassword(
        username: widget.username, // Lấy username từ widget
        resetCode: resetCode,
        newPassword: newPassword,
      );

      if (success) {
        Navigator.pushNamed(context, '/login'); // Điều hướng về Login khi thành công
      } else {
        print("Reset password failed!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Nhập mã xác nhận",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        hintText: "Mã xác nhận",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Mật khẩu mới",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity, // Chiều rộng full màn hình
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Màu nền của nút
                          foregroundColor: Colors.white, // Màu chữ
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Bo góc cho nút
                          ),
                        ),
                        onPressed: _submitResetPassword,
                        child: const Text(
                          "OK",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
