import 'package:flutter/material.dart';
import 'package:techshop_flutter/routes/routes.dart';
import '../../models/OrderModel.dart';
import '../../shared/services/order/OrderService.dart';
import '../../shared/constant/constants.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  final OrderService _orderService = OrderService();
  late Future<List<OrderModel>> _futureOrders;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _futureOrders = _orderService.getOrders(); // Lấy danh sách đơn hàng
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Hàm trả về màu sắc trạng thái
  Color getStatusColor(String status) {
    switch (status) {
      case 'Đã mua':
        return AppColors.statusBought;
      case 'Đang xử lý':
        return AppColors.statusProcessing;
      case 'Đang giao':
        return AppColors.statusDelivered;
      case 'Đã giao':
        return AppColors.statusAlDelivered;
      case 'Đã hủy':
        return AppColors.statusCancelled;
      default:
        return AppColors.statusDefault;
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelPadding: const EdgeInsets.only(left: 0, right: 35), // Điều chỉnh padding giữa các tab
          indicatorColor: AppColors.primaryColor,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đang xử lý'),
            Tab(text: 'Đang giao'),
            Tab(text: 'Đã giao'),
            Tab(text: 'Đã hủy'),
          ],
        ),
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
          return TabBarView(
            controller: _tabController,
            children: [
              buildOrderList(orders, null), // Tất cả
              buildOrderList(orders, 'Đang xử lý'),
              buildOrderList(orders, 'Đang giao'),
              buildOrderList(orders, 'Đã giao'),
              buildOrderList(orders, 'Đã hủy'),
            ],
          );
        },
      ),
    );
  }

  Widget buildOrderList(List<OrderModel> orders, String? statusFilter) {
    final filteredOrders = statusFilter == null
        ? orders
        : orders.where((order) => order.status == statusFilter).toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng nào'));
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        final orderName = limitText(order.derivedOrderName, 10);
        final receiver = order.receiver;
        final status = order.status;

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: Image.network(
              order.orderDetails.first.productResponseDTO.img,
              width: 70,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error),
            ),
            title: Text(
              orderName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Khách hàng: $receiver\nTổng tiền: ${order.totalAmount.toString()}đ',
              style: const TextStyle(color: AppColors.textMutedColor),
            ),
            trailing: Text(
              status,
              style: TextStyle(
                color: getStatusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/orderDetail', // Sử dụng route name
                arguments: order, // Truyền đối tượng `OrderModel` qua `arguments`
              );
            },
          ),
        );
      },
    );
  }

  String limitText(String text, int maxChars) {
    if (text.length > maxChars) {
      return '${text.substring(0, maxChars)}...';
    }
    return text;
  }
}
