import 'package:flutter/material.dart';

import '../../models/customer/CustomerModel.dart';
import '../../routes/routes.dart';
import '../../shared/services/account/AccountService.dart';
import '../../shared/utils/shared_preferences.dart';

class GetProfile extends StatefulWidget {
  final int id; // Nhận ID từ màn hình khác

  const GetProfile({super.key, required this.id});

  @override
  State<GetProfile> createState() => _GetProfileState();
}

class _GetProfileState extends State<GetProfile> {
  CustomerModel? _customer; // Biến lưu thông tin tài khoản
  bool _isLoading = true; // Biến trạng thái loading

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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin tài khoản'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50, color: Colors.white),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Xin chào',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _customer!.username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Họ & Tên',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        _customer!.fullname.isNotEmpty
                            ? _customer!.fullname
                            : 'Chưa cập nhật',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        _customer!.email,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số điện thoại',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        _customer!.phone.isNotEmpty
                            ? _customer!.phone
                            : 'Chưa cập nhật',
                        style: const TextStyle(fontSize: 16),
                      ),

                    ],
                  ),

                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(double.infinity, 10),
                    ),
                    onPressed: () async {
                      final userId = await SharedPreferencesHelper.getUserId();
                      if (userId != null) {
                        Navigator.pushNamed(
                          context,
                          Routes.editAccount,
                          arguments: userId,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in to view your account.')),
                        );
                      }
                    },
                    child: const Text(
                      'Cập nhật tài khoản',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      minimumSize: const Size(double.infinity, 10),
                    ),
                    onPressed: () async {
                      final userId = await SharedPreferencesHelper.getUserId();
                      if (userId != null) {
                        Navigator.pushNamed(
                          context,
                          Routes.updatePassword,
                          arguments: userId,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please log in to view your account.')),
                        );
                      }
                    },
                    child: const Text(
                      'Cập nhật mật khẩu',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10.0), // Khoảng cách phía trên
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(double.infinity, 10),
                ),
                onPressed: () async {
                  await SharedPreferencesHelper.clearUserData();
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
