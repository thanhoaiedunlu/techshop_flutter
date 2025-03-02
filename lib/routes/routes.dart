import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/models/OrderModel.dart';
import 'package:techshop_flutter/screens/Account/GetProfile.dart';
import 'package:techshop_flutter/screens/account/EditProfile.dart';
import 'package:techshop_flutter/screens/account/UpdatePassword.dart';
import 'package:techshop_flutter/screens/address/Address.dart';
import 'package:techshop_flutter/screens/cart/Cart.dart';
import 'package:techshop_flutter/screens/detailProduct/DetailProduct.dart';
import 'package:techshop_flutter/screens/forgotPassword/enterUsername.dart';
import 'package:techshop_flutter/screens/home/home.dart';
import 'package:techshop_flutter/screens/login/login.dart';
import 'package:techshop_flutter/screens/order/OrderInformation.dart';
import 'package:techshop_flutter/screens/order/orderDetail.dart';
import 'package:techshop_flutter/screens/order/orderHistory.dart';
import 'package:techshop_flutter/screens/productCategory/ProductCategory.dart';
import 'package:techshop_flutter/screens/seachProduct/ProductSearch.dart';

import '../models/CartItemModel.dart';

class Routes {
  static const String home = '/home';
  static const String receipt = '/receipt';
  static const String account = '/account';
  static const String login = '/login';
  static const String productSearch = '/productSearch';
  static const String editAccount = '/editAccount';
  static const String productDetail = '/productDetail';
  static const String cart = '/cart';
  static const String productCategory = '/productCategory';
  static const String checkout = '/checkout';
  static const String addressList = '/addressList';
  static const String orderHistoryClient = '/orderHistoryClient';
  static const String orderHistoryDetail = '/orderHistoryDetail';
  static const String  enterUserName= '/enterUsername';
  static const String  updatePassword= '/updatePassword';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case receipt:
        // Placeholder for receipt screen
        return _errorRoute();
      case account:
        if (settings.arguments is int) {
          final args = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => GetProfile(id: args),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu
      case login:
        return MaterialPageRoute(builder: (_) => const Login());
      case productSearch:
        return MaterialPageRoute(builder: (_) => const ProductSearch());
      case editAccount:
        if (settings.arguments is int) {
          final args = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => EditProfile(id: args),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu
      case productDetail:
        if (settings.arguments is int) {
          final args = settings.arguments as int; // Nhận productId từ arguments
          return MaterialPageRoute(
            builder: (_) => DetailProduct(productId: args),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case productCategory:
        if (settings.arguments is CategoryModel) {
          final category = settings.arguments as CategoryModel;
          return MaterialPageRoute(
            builder: (_) => ProductByCategoryScreen(
              categoryId: category.id,
              categoryName: category.name,
            ),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu
      case checkout:
        if (settings.arguments is List<CartItemModel>) {
          final cartItems = settings.arguments as List<CartItemModel>;
          return MaterialPageRoute(
            builder: (_) => OrderSummaryPage(cartItems: cartItems),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu
      case addressList:
        return MaterialPageRoute(builder: (_) => const AddressListPage());
      case orderHistoryClient:
        if (settings.arguments is int) {
          final args = settings.arguments as int; // Nhận productId từ arguments
          return MaterialPageRoute(
            builder: (_) => OrderHistoryScreen(customerId: args),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu
        // Màn hình lịch sử đơn hàng
        // return MaterialPageRoute(
        //   builder: (_) => OrderHistoryScreen(),
        // );
      case enterUserName:
        return MaterialPageRoute(builder: (_)=> EnterUsername(),
        );
      case updatePassword:
        if (settings.arguments is int) {
          final customerId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => UpdatePassword(customerId: customerId),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu

      case orderHistoryDetail:
        // Giả sử bạn truyền thẳng OrderModel sang màn hình chi tiết
        // Hoặc chỉ truyền orderId (tuỳ bạn)
        if (settings.arguments is OrderModel) {
          final order = settings.arguments as OrderModel;
          return MaterialPageRoute(
            builder: (_) => OrderDetailScreen(order: order),
          );
        }
        return _errorRoute(); // Nếu arguments không đúng kiểu/ Nếu arguments không đúng kiểu
      default:
        return _errorRoute(); // Trường hợp không tìm thấy route
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No route defined for this path')),
      ),
    );
  }
}
