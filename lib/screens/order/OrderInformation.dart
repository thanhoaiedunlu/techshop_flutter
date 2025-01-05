import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CartItemModel.dart';
import 'package:techshop_flutter/models/address/AddressModel.dart';
import 'package:techshop_flutter/models/order/OrderRequestDto.dart';
import 'package:techshop_flutter/routes/routes.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:techshop_flutter/shared/services/address/AddressService.dart';
import 'package:techshop_flutter/shared/services/cartItem/CartItemService.dart';
import 'package:techshop_flutter/shared/services/order/OrderService.dart';
import 'package:techshop_flutter/shared/utils/shared_preferences.dart';

// Enum mở rộng 4 phương thức, nhưng ví dụ này chỉ gắn radio cho COD, MOMO.

class OrderSummaryPage extends StatefulWidget {
  final List<CartItemModel> cartItems;

  const OrderSummaryPage({super.key, required this.cartItems});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late Future<AddressModel?> _addressFuture;
  final AddressService _addressService = AddressService();
  bool _isSubmitting = false;

  /// Biến lưu phương thức thanh toán hiện tại (radio)
  PaymentMethod _selectedPaymentMethod = PaymentMethod.COD;

  @override
  void initState() {
    super.initState();
    _addressFuture = _getDefaultAddress();
  }

  Future<AddressModel?> _getDefaultAddress() async {
    final customerId = await SharedPreferencesHelper.getUserId();
    if (customerId == null) return null;
    return await _addressService.getAddressByCustomerIdAndIsDefault(customerId);
  }

  /// Tính tổng giá
  double get totalPrice {
    return widget.cartItems.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  String convertPaymentMethodToString(PaymentMethod pm) {
    switch (pm) {
      case PaymentMethod.COD:
        return "COD";
      case PaymentMethod.MOMO:
        return "MOMO";
      case PaymentMethod.ZALO_PAY:
        return "ZALO_PAY";
      case PaymentMethod.VN_PAY:
        return "VN_PAY";
    }
  }

  /// Hàm bấm nút "Xác nhận Đặt hàng"
  void _confirmOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final customerId = await SharedPreferencesHelper.getUserId();
      final cartId = await SharedPreferencesHelper.getCartIdByUserLogin();
      if (customerId == null) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn cần đăng nhập để đặt hàng.')),
        );
        return;
      }

      // Lấy danh sách chi tiết
      final orderDetails = widget.cartItems.map((item) {
        return OrderDetailRequestDto(
          productId: item.product.id,
          quantity: item.quantity,
        );
      }).toList();

      final addressModel = await _addressFuture;
      if (addressModel == null) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Vui lòng thêm địa chỉ trước khi đặt hàng.')),
        );
        return;
      }

      // Tạo dto
      final dto = OrderRequestDto(
        customerId: customerId,
        totalAmount: totalPrice.toInt(),
        address: addressModel.address,
        numberPhone: addressModel.numberPhone,
        receiver: addressModel.receiver,
        orderDetails: orderDetails,
      );

      final methodString = _mapPaymentMethodToServer(_selectedPaymentMethod);
      final statusString =
          methodString == "COD" ? "PENDING" : "PENDING_PAYMENT";

      final orderId = await OrderService.saveOrder(
        methodString,
        statusString,
        dto,
      );
      setState(() => _isSubmitting = false);

      if (orderId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đặt hàng thành công! Mã đơn: $orderId')),
        );
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đặt hàng thất bại! Vui lòng thử lại.')),
        );
      }
      var bool = await CartItemService.deleteCartItemByCartId(cartId!);
    } catch (e) {
      print('Exception in _confirmOrder: $e');
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi tạo đơn hàng.')),
      );
    }
  }

// Hàm map enum Flutter -> string
  String _mapPaymentMethodToServer(PaymentMethod pm) {
    switch (pm) {
      case PaymentMethod.COD:
        return "COD";
      case PaymentMethod.MOMO:
        return "MOMO";
      case PaymentMethod.ZALO_PAY:
        return "ZALO_PAY";
      case PaymentMethod.VN_PAY:
        return "VN_PAY";
    }
  }

  /// Điều hướng đến danh sách địa chỉ
  Future<void> _navigateToAddressList() async {
    final result = await Navigator.pushNamed(context, Routes.addressList);
    if (result == true) {
      // Reload lại địa chỉ mặc định
      setState(() {
        _addressFuture = _getDefaultAddress();
      });
    }
  }

  /// Widget chọn phương thức thanh toán
  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RadioListTile<PaymentMethod>(
            title: const Text('Thanh toán khi nhận hàng (COD)'),
            value: PaymentMethod.COD,
            groupValue: _selectedPaymentMethod,
            onChanged: (PaymentMethod? value) {
              if (value != null) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              }
            },
          ),
          RadioListTile<PaymentMethod>(
            title: const Text('Thanh toán bằng Momo'),
            value: PaymentMethod.MOMO,
            groupValue: _selectedPaymentMethod,
            onChanged: (PaymentMethod? value) {
              if (value != null) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              }
            },
          ),
          // Nếu muốn hỗ trợ ZaloPay và VNPay, thêm RadioListTile tương tự bên dưới:
          RadioListTile<PaymentMethod>(
              title: const Text('Thanh toán bằng Zalo Pay'),
              value: PaymentMethod.ZALO_PAY,
              groupValue: _selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                }
              }),
          RadioListTile<PaymentMethod>(
              title: const Text('Thanh toán bằng VN Pay'),
              value: PaymentMethod.VN_PAY,
              groupValue: _selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                }
              }),
        ],
      ),
    );
  }

  // ================= BUILD UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận Đơn hàng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Địa chỉ người nhận ======
            FutureBuilder<AddressModel?>(
              future: _addressFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingAddressSection();
                } else if (snapshot.hasError) {
                  return _buildErrorAddressSection();
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return _buildNoAddressSection();
                } else {
                  final address = snapshot.data!;
                  return GestureDetector(
                    onTap: _navigateToAddressList,
                    child: _buildAddressSection(address),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // ====== Danh sách sản phẩm ======
            const Text(
              'Sản phẩm đã chọn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(item.product.img),
                  ),
                  title: Text(item.product.name),
                  subtitle: Text('Số lượng: ${item.quantity}'),
                  trailing: Text(
                    '${(item.product.price * item.quantity).toStringAsFixed(0)} VND',
                  ),
                );
              },
            ),
            const Divider(thickness: 1, height: 32),

            // ====== Radio chọn phương thức thanh toán ======
            _buildPaymentMethodSection(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ====== Tổng cộng ======
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
                  '${totalPrice.toStringAsFixed(0)} VND',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ====== Nút xác nhận đặt hàng ======
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Xác nhận Đặt hàng',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CÁC WIDGET PHỤ =================
  Widget _buildLoadingAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: const Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Đang tải địa chỉ...'),
        ],
      ),
    );
  }

  Widget _buildErrorAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Không tải được địa chỉ. Vui lòng thử lại.',
              style: TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _addressFuture = _getDefaultAddress();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Chưa có địa chỉ mặc định. Vui lòng thêm địa chỉ mới.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, Routes.addressList).then((_) {
                setState(() {
                  _addressFuture = _getDefaultAddress();
                });
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(AddressModel address) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.receiver} - ${address.numberPhone}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  address.address,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
