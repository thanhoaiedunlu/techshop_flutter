import 'package:flutter/material.dart';

import '../../../routes/routes.dart';
import '../../ultis/shared_preferences.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex; // Tab hiện tại

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState
    extends State<CustomBottomNavigationBar> {
  // Hàm xử lý khi tab được chọn
  Future<void> _onTabTapped(int index) async {
    // Dẫn đến các màn hình tương ứng khi bấm vào các tab
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/receipt');
        break;
      case 2:
        Navigator.pushNamed(context, '/cart');
        break;
      case 3:
        final userId = await SharedPreferencesHelper.getUserId();
        if (userId != null) {
          Navigator.pushNamed(
            context,
            Routes.account,
            arguments: userId,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please log in to view your account.')),
          );
        }
        break;
    }
  }

  // Hàm hiển thị hộp thoại đăng xuất
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully!')),
                );
                // Đăng xuất thành công, có thể làm gì đó ở đây
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Phân bổ đều các mục
      currentIndex: widget.currentIndex,
      onTap: _onTabTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(size: 30.0), // Đồng bộ kích thước biểu tượng
      unselectedIconTheme: const IconThemeData(size: 30.0), // Đồng bộ kích thước biểu tượng
      showSelectedLabels: true, // Hiển thị nhãn cho mục được chọn
      showUnselectedLabels: true, // Hiển thị nhãn cho mục không được chọn
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Receipt',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Account',
        ),
      ],
    );
  }

}
