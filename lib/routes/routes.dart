import 'package:flutter/material.dart';
import 'package:techshop_flutter/screens/forgotPassword/enterUsername.dart';
import 'package:techshop_flutter/screens/home/home.dart';
import 'package:techshop_flutter/screens/login/login.dart';
import '../screens/forgotPassword/enterCode.dart';

class Routes {
  // Định nghĩa các route của ứng dụng
  static const String home = '/';
  static const String receipt = '/receipt';
  static const String account = '/account';
  static const String login = '/login';

  // Phương thức điều hướng
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case receipt:
      // return MaterialPageRoute(builder: (_) => DetailScreen());
      case account:
      // return MaterialPageRoute(builder: (_) => AccountScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const Login());
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
