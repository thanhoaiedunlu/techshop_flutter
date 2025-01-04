import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/screens/Account/GetProfile.dart';
import 'package:techshop_flutter/screens/account/EditProfile.dart';
import 'package:techshop_flutter/screens/address/Address.dart';
import 'package:techshop_flutter/screens/cart/Cart.dart';
import 'package:techshop_flutter/screens/detailProduct/DetailProduct.dart';
import 'package:techshop_flutter/screens/home/home.dart';
import 'package:techshop_flutter/screens/login/login.dart';
import 'package:techshop_flutter/screens/order/OrderInformation.dart';
import 'package:techshop_flutter/screens/productCategory/ProductCategory.dart';
import 'package:techshop_flutter/screens/seachProduct/ProductSearch.dart';

import '../models/CartItemModel.dart';

class Routes {
  static const String home = '/';
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
