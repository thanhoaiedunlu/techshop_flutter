import 'package:flutter/material.dart';
import 'package:techshop_flutter/shared/services/cart/CartService.dart';
import 'package:techshop_flutter/shared/services/cartItem/CartItemService.dart';
import '../../../routes/routes.dart';
import '../../utils/shared_preferences.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex; // Tab hiện tại

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState(); // Đổi tên State thành public
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  // Biến lưu số lượng sản phẩm trong giỏ
  int _cartItemCount = 0;

  // Service gọi API lấy số lượng cart
  final CartItemService cartItemService = CartItemService();
  final CartService cartService = CartService();

  @override
  void initState() {
    super.initState();
    _loadCartItemCount();
  }

  /// Hàm tải số lượng sản phẩm từ API
  Future<void> _loadCartItemCount() async {
    final cartId = await SharedPreferencesHelper.getCartIdByUserLogin();
    if (cartId != null) {
      final quantity = await cartService.getQuantityCartItemInCart(cartId);
      if (quantity != null) {
        setState(() {
          _cartItemCount = quantity;
        });
      }
    }
  }

  /// Hàm public để **bên ngoài** gọi, cập nhật badge
  Future<void> refreshBadge() async {
    await _loadCartItemCount();
  }

  // Hàm xử lý khi tab được chọn
  Future<void> _onTabTapped(int index) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, Routes.orderHistoryClient);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.cart);
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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      onTap: _onTabTapped,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedIconTheme: const IconThemeData(size: 30.0),
      unselectedIconTheme: const IconThemeData(size: 30.0),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Receipt',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              if (_cartItemCount > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$_cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Account',
        ),
      ],
    );
  }
}
