import 'package:flutter/material.dart';
import 'package:techshop_flutter/screens/home/home.dart';

class Routes {
  // Định nghĩa các route của ứng dụng
  static const String home = '/home';
  static const String receipt = '/receipt';
  static const String account = '/account';


  // Phương thức điều hướng
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        print('vao dc');
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case receipt:
        // return MaterialPageRoute(builder: (_) => DetailScreen());
      case account:
        // return MaterialPageRoute(builder: (_) => AccountScreen());
      default:
        return _errorRoute();
    }
  }

  // Phương thức hiển thị khi không tìm thấy route
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No route defined for this path')),
      ),
    );
  }
}
