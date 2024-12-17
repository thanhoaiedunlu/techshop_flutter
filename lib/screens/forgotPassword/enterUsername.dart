import 'package:flutter/material.dart';

import '../../shared/services/forgotPassword/PasswordResetService.dart';
import 'enterCode.dart';

class EnterUsername extends StatefulWidget {
  const EnterUsername({super.key});

  @override
  State<EnterUsername> createState() => _EnterUsernameState();
}

class _EnterUsernameState extends State<EnterUsername> {
  final TextEditingController _usernameController = TextEditingController();
  final PasswordResetService _service = PasswordResetService();
  void _submitUsername() async {
    final username = _usernameController.text;

    if (username.isNotEmpty) {
      bool success = await _service.initPasswordReset(username: username);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset request sent successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterCode(username: _usernameController.text.trim()),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send request. Try again!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300], // Màu nền chính
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
                  borderRadius: BorderRadius.circular(20), // Bo góc
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // Đổ bóng
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tiêu đề Forgot Password
                    const Text(
                      "Quên mật khẩu",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ô nhập username
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Tên đăng nhập",
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nút Sent
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          _submitUsername(); // Gọi hàm xử lý logic khi nhấn nút
                        },
                        child: const Text(
                          "Gửi",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
