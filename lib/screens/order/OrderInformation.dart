import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CartItemModel.dart';
import 'package:techshop_flutter/models/address/AddressModel.dart';
import 'package:techshop_flutter/routes/routes.dart';
import 'package:techshop_flutter/shared/services/address/AddressService.dart';
import 'package:techshop_flutter/shared/utils/shared_preferences.dart';

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

  double get totalPrice {
    return widget.cartItems
        .fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  void _confirmOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    // TODO: Thực hiện gọi API đặt hàng với widget.cartItems
    // Ví dụ giả sử gọi API thành công:
    bool success = true; // Thay bằng kết quả từ API thực tế

    await Future.delayed(
        const Duration(seconds: 2)); // Giả lập thời gian gọi API

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã được đặt thành công!')),
      );
      Navigator.popUntil(
          context, ModalRoute.withName(Routes.home)); // Quay về trang chính
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đặt hàng thất bại! Vui lòng thử lại.')),
      );
    }
  }

  Future<void> _navigateToAddressList() async {
    final result = await Navigator.pushNamed(context, Routes.addressList);
    if (result == true) {
      // Nếu địa chỉ đã được thay đổi, reload địa chỉ mặc định
      setState(() {
        _addressFuture = _getDefaultAddress();
      });
    }
  }

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
            // Địa chỉ người nhận
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

            // Danh sách sản phẩm
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
                      '${(item.product.price * item.quantity).toStringAsFixed(0)} VND'),
                );
              },
            ),
            const Divider(thickness: 1, height: 32),

            // Các phần khác như Bảo hiểm, Voucher, Lời nhắn cho Shop, Phương thức vận chuyển
            // Bạn có thể thêm các phần này tương tự như trong CheckoutPage nếu cần
            // Ví dụ:
            // _buildInsuranceSection(),
            // _buildVoucherSection(),
            // _buildMessageSection(),
            // _buildShippingMethodSection(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tổng cộng
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
            // Nút xác nhận đặt hàng
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

  // Phần xây dựng các widget con

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
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
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
          const Icon(
            Icons.location_off,
            color: Colors.grey,
          ),
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
          const Icon(
            Icons.location_on_outlined,
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${address.receiver} - ${address.numberPhone}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.address,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
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
