import 'package:flutter/material.dart';
import 'package:techshop_flutter/screens/admin/productManagement/ProductManagement.dart';
import 'package:techshop_flutter/shared/widgets/category/categoryList.dart';

import 'category/CategoryManagement.dart';
import 'customer/CustomerManagement.dart';

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Hi Admin',
            style: TextStyle(
          color: Colors.white,
        )),
        leading: const CircleAvatar(
          backgroundImage: NetworkImage('https://res.cloudinary.com/drvydie5q/image/upload/v1735782747/Dynamic%20folders/h0ddx53n8jepv0cmxuaq.jpg'), // Thay ảnh avatar
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          margin: const EdgeInsets.only(top: 30.0),
          child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildDashboardItem(
              context,
              icon: Icons.bar_chart,
              label: 'Thống Kê',
              color: Colors.blue,
            ),
            _buildDashboardItem(
              context,
              icon: Icons.people,
              label: 'Khách Hàng',
              color: Colors.orange,
            ),
            _buildDashboardItem(
              context,
              icon: Icons.shopping_basket,
              label: 'Đơn Hàng',
              color: Colors.pink,
            ),
            _buildDashboardItem(
              context,
              icon: Icons.category,
              label: 'Danh Mục',
              color: Colors.blueAccent,
            ),
            _buildDashboardItem(
              context,
              icon: Icons.inventory,
              label: 'Sản Phẩm',
              color: Colors.green,
            ),
            _buildDashboardItem(
              context,
              icon: Icons.logout,
              label: 'Đăng Xuất',
              color: Colors.purpleAccent,
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context,
      {required IconData icon, required String label, required Color color}) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Thống Kê':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
            );
            break;
          case 'Khách Hàng':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomerManagementScreen()),
            );
            break;
          case 'Đơn Hàng':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
            );
            break;
          case 'Danh Mục':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
            );
            break;
          case 'Sản Phẩm':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductManagementScreen()),
            );
            break;
          case 'Đăng Xuất':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Không tìm thấy trang cho $label')),
            );
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
