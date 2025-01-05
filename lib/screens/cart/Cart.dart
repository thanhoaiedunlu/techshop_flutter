import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:techshop_flutter/models/CartItemModel.dart';
import 'package:techshop_flutter/screens/order/OrderInformation.dart';
import 'package:techshop_flutter/shared/services/cart/CartService.dart';
import 'package:techshop_flutter/shared/services/cartItem/CartItemService.dart';
import 'package:techshop_flutter/shared/utils/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItemModel> _cartItems = [];
  double _totalPrice = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      final cart = await CartService().getCartByUserIsLogin(userId);
      if (cart != null) {
        setState(() {
          _cartItems = cart.cartItems;
          _calculateTotalPrice();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải giỏ hàng.')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin người dùng.')),
      );
    }
  }

  void _calculateTotalPrice() {
    _totalPrice = _cartItems.fold<double>(
      0,
          (total, item) => total + (item.product.price * item.quantity),
    );
  }

  Future<void> _updateQuantity(CartItemModel item, int quantityChange) async {
    final updatedItem =
    await CartItemService().updateQuantityCartItem(item.id, quantityChange);
    if (updatedItem != null) {
      setState(() {
        final index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
        if (index != -1) {
          _cartItems[index] = updatedItem;
          _calculateTotalPrice();
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật số lượng thất bại!')),
      );
    }
  }

  Future<void> _removeCartItem(CartItemModel item) async {
    final isDeleted = await CartItemService().deleteCartItem(item.id);
    if (isDeleted) {
      setState(() {
        _cartItems.removeWhere((cartItem) => cartItem.id == item.id);
        _calculateTotalPrice();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa sản phẩm thất bại!')),
      );
    }
  }

  void _incrementQuantity(CartItemModel item) {
    setState(() {
      item.quantity++;
      _calculateTotalPrice();
    });
    _updateQuantity(item, 1);
  }

  void _decrementQuantity(CartItemModel item) {
    if (item.quantity > 1) {
      setState(() {
        item.quantity--;
        _calculateTotalPrice();
      });
      _updateQuantity(item, -1);
    } else {
      _removeCartItem(item);
    }
  }

  void _checkout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSummaryPage(cartItems: _cartItems),
      ),
    );
  }
  String formattedPrice(double totalPrice) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'vn₫');
    return formatter.format(totalPrice);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _cartItems.isEmpty
          ? const Center(
        child: Text(
          'Giỏ hàng của bạn đang trống!',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: NetworkImage(item.product.img),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Giá: ${item.product.formattedPrice}',
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _decrementQuantity(item),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _incrementQuantity(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeCartItem(item),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng cộng:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedPrice(_totalPrice),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _checkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Thanh Toán',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
