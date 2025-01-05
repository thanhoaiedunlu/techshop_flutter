import 'dart:convert'; // Dùng để giải quyết lỗi ký tự UTF-8
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng ngày
import 'package:techshop_flutter/shared/services/order/OrderService.dart';
import '../../models/OrderModel.dart';
import '../../routes/routes.dart';
import '../../shared/constant/constants.dart';
import '../../shared/utils/shared_preferences.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Định dạng ngày đặt hàng
    final formattedOrderDate =
    DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(order.orderDate));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getOrderStatusText(order.status), // Hiển thị trạng thái đơn hàng
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Phần thông tin người nhận
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${order.receiver} (${order.numberPhone})\n'
                              '${order.address}\n'
                              'Ngày đặt hàng: $formattedOrderDate',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[300]),

            // Danh sách sản phẩm
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Sản phẩm:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.orderDetails.length,
              itemBuilder: (context, index) {
                final detail = order.orderDetails[index];
                final product = detail.productResponseDTO;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 80),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(product.price)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Số lượng: ${detail.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            // Text(
                            //   'Mô tả: ${product.detail}',
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.black54,
                            //   ),
                            // ),
                            const SizedBox(height: 5),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[300]),

            // Thông tin liên hệ
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin liên hệ:',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 10),
                      Text('1900 123 456 (24/7)',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Icon(Icons.email, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('hotro@example.com',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: order.status == 'Đang chờ xử lý'
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _cancelOrder(context, order.id); // Gọi hàm hủy đơn hàng
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Hủy đơn hàng',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      )
          : order.status == 'Đang giao hàng'
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _confirmReceived(context, order.id); // Gọi hàm xác nhận đã nhận hàng
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Đã nhận được hàng',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ) : null,
    );
  }

  // Hàm chuyển trạng thái đơn hàng thành text mô tả
  String getOrderStatusText(String status) {
    switch (status) {
      case 'Đã giao':
        return 'Đơn hàng đã giao';
      case 'Đang xử lý':
        return 'Đơn hàng đang được xử lý';
      case 'Đang giao':
        return 'Đơn hàng đang được giao';
      case 'Đã hủy':
        return 'Đơn hàng đã bị hủy';
      default:
        return 'Trạng thái đơn hàng không xác định';
    }
  }

  // Hàm hủy đơn hàng
  void _cancelOrder(BuildContext context, int orderId) {
    final OrderService orderService = OrderService();
    // Gửi yêu cầu API hủy đơn hàng
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () async {
              // Thực hiện logic hủy đơn hàng ở đây
              // Gọi API hủy đơn hàng và hiển thị thông báo
              String result = await orderService.updateOrderStatus("CANCELLED", orderId);
              final userId = await SharedPreferencesHelper.getUserId();
              Navigator.pushNamed(context, Routes.orderHistoryClient,arguments: userId,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đơn hàng đã được hủy')),
              );
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }
  void _confirmReceived(BuildContext context, int orderId) {
    final OrderService orderService = OrderService();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận nhận hàng'),
        content: const Text('Bạn có chắc chắn rằng bạn đã nhận được hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () async {
              // Gọi API cập nhật trạng thái thành "Đã giao"
              String result = await orderService.updateOrderStatus("DELIVERED", orderId);

              final userId = await SharedPreferencesHelper.getUserId();
              Navigator.pushNamed(
                context,
                Routes.orderHistoryClient,
                arguments: userId,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(result)),
              );
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

}
