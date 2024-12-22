import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CustomerModel.dart';

import '../../shared/services/account/AccountService.dart';

class EditProfile extends StatefulWidget {
  final int id; // Nhận ID từ màn hình khác

  const EditProfile({super.key, required this.id});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  CustomerModel? _customer; // Biến lưu thông tin tài khoản
  bool _isLoading = true; // Biến trạng thái loading

  // Controllers cho các input fields
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfile(); // Gọi API khi giao diện được khởi tạo
  }

  Future<void> _fetchProfile() async {
    final accountService = AccountService();
    final customer = await accountService.getProfile(widget.id);
    setState(() {
      _customer = customer;
      if (_customer != null) {
        // Đặt giá trị ban đầu cho các input fields
        _fullnameController.text = _customer!.fullname;
        _emailController.text = _customer!.email;
        _phoneController.text = _customer!.phone;
        _passwordController.text = _customer!.password;
      }
      _isLoading = false;
    });
  }

  Future<void> _updateProfile() async {
    final updatedCustomer = CustomerModel(
      id: _customer!.id,
      fullname: _fullnameController.text,
      username: _customer!.username,
      // Username không thay đổi
      email: _emailController.text,
      phone: _phoneController.text,
      role: _customer!.role,
      cartId: _customer!.cartId,
      password: _customer!.password,
    );

    final accountService = AccountService();
    final success = await accountService.updateProfile(updatedCustomer);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật tài khoản thành công!')),
      );
      Navigator.pop(context, '/'); // Quay lại màn hình trước đó
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật tài khoản thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật tài khoản'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Hiển thị trạng thái loading
            )
          : _customer == null
              ? const Center(
                  child: Text('Không thể tải thông tin tài khoản!'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _fullnameController,
                        decoration: const InputDecoration(
                          labelText: 'Họ & Tên',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Số điện thoại',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mật khẩu',
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(12.0)),
                          ),
                        ),
                        obscureText: true, // Thuộc tính che mật khẩu
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _updateProfile,
                        child: const Text(
                          'Lưu',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
