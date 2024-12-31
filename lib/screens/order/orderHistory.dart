import 'package:flutter/material.dart';
import '../../models/OrderModel.dart';
import '../../shared/services/order/OrderService.dart';
import '../../shared/constant/constants.dart';
import 'orderDetail.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();
  late Future<List<OrderModel>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _orderService.getOrders(); // Lấy danh sách đơn hàng

  }

  // Hàm trả về màu sắc trạng thái
  Color getStatusColor(String status) {
    switch (status) {
      case 'Đã mua':
        return AppColors.statusBought; // Màu cho trạng thái "Đã mua"
      case 'Đã giao':
        return AppColors.statusDelivered; // Màu cho trạng thái "Đã giao"
      case 'Đã hủy':
        return AppColors.statusCancelled; // Màu cho trạng thái "Đã hủy"
      case 'Đang xử lý':
        return AppColors.statusProcessing; // Màu cho trạng thái "Đang xử lý"
      default:
        return AppColors.statusDefault; // Màu mặc định
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại trang trước
          },
        ),
        centerTitle: true,
        title: const Text(
          'Lịch Sử Mua Hàng',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Thực hiện tìm kiếm
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundLightColor,
      body: FutureBuilder<List<OrderModel>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có đơn hàng nào'));
          }

          final orders = snapshot.data!;
          final allOrderDetails = orders.expand((order) => order.orderDetails).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allOrderDetails.length,
            itemBuilder: (context, index) {
              final detail = allOrderDetails[index];
              final product = detail.productResponseDTO;
              final order = orders.firstWhere((order) => order.orderDetails.contains(detail));

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  leading: Image.network(
                    product.img,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    'Giá: ${product.price}đ\nSố lượng: ${detail.quantity}',
                    style: const TextStyle(color: AppColors.textMutedColor),
                  ),
                  trailing: Text(
                    order.status,
                    style: TextStyle(
                      color: getStatusColor(order.status),
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: orders.firstWhere((order) => order.orderDetails.contains(detail))),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Xóa nội dung tìm kiếm
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng giao diện tìm kiếm
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Kết quả tìm kiếm (tùy chỉnh theo logic của bạn)
    return Center(child: Text('Kết quả cho: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Gợi ý tìm kiếm (tùy chỉnh theo logic của bạn)
    return Center(child: Text('Gợi ý cho: $query'));
  }
}
