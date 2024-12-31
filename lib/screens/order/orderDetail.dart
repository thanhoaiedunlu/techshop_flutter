import 'dart:convert'; // Dùng để giải quyết lỗi ký tự UTF-8
import 'package:flutter/material.dart';
import '../../models/OrderModel.dart';
import '../../shared/constant/constants.dart';
import 'package:intl/intl.dart'; // Thư viện định dạng ngày

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Định dạng ngày đặt hàng
    final formattedOrderDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(order.orderDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi Tiết Đơn Hàng',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần trạng thái đơn hàng
              Container(
                color: order.status == 'Đã giao'
                    ? Colors.green[100]
                    : order.status == 'Đang xử lý'
                    ? Colors.orange[100]
                    : Colors.red[100],
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      order.status == 'Đã giao'
                          ? Icons.check_circle
                          : order.status == 'Đang xử lý'
                          ? Icons.access_time
                          : Icons.cancel,
                      color: order.status == 'Đã giao'
                          ? Colors.green
                          : order.status == 'Đang xử lý'
                          ? Colors.orange
                          : Colors.red,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Trạng thái: ${order.status}',
                        style: TextStyle(
                          color: order.status == 'Đã giao'
                              ? Colors.green
                              : order.status == 'Đang xử lý'
                              ? Colors.orange
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                                'Ngày đặt hàng: $formattedOrderDate', // Hiển thị ngày đặt hàng
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                'Mô tả: ${product.detail}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Giá: ${product.price}đ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Số lượng: ${detail.quantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.phone, color: Colors.green),
                        SizedBox(width: 10),
                        Text('1900 123 456 (24/7)', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Icon(Icons.email, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('hotro@example.com', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),

              // Nút mua ngay/mua lại
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.circle, size: 12, color: Colors.black),
                      const SizedBox(width: 10),
                      Text(
                        order.status == 'Đã giao' ? 'Mua lại' : 'Mua ngay',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
