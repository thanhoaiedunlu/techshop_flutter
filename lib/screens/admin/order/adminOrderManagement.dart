import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/OrderModel.dart';
import 'package:techshop_flutter/screens/order/orderDetail.dart';
import 'package:techshop_flutter/shared/services/order/adminOrderService.dart';
import 'package:techshop_flutter/shared/services/order/OrderService.dart';

class AdminOrderManagement extends StatefulWidget {
  const AdminOrderManagement({super.key});

  @override
  _AdminOrderManagementState createState() => _AdminOrderManagementState();
}

class _AdminOrderManagementState extends State<AdminOrderManagement>
    with SingleTickerProviderStateMixin {
  final AdminOrderService _adminOrderService = AdminOrderService();
  final OrderService _orderService = OrderService();

  late TabController _tabController;

  // Tạo 5 Future<List<OrderModel>> cho mỗi status
  late Future<List<OrderModel>> _pendingPaymentOrders;
  late Future<List<OrderModel>> _pendingOrders;
  late Future<List<OrderModel>> _shippingOrders;
  late Future<List<OrderModel>> _deliveredOrders;
  late Future<List<OrderModel>> _canceledOrders;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Gọi API lấy đơn hàng theo các status
    _pendingPaymentOrders = _orderService.getOrdersByStatus("PENDING_PAYMENT");
    _pendingOrders = _orderService.getOrdersByStatus("PENDING");
    _shippingOrders = _orderService.getOrdersByStatus("SHIPPING");
    _deliveredOrders = _orderService.getOrdersByStatus("DELIVERED");
    _canceledOrders = _orderService.getOrdersByStatus("CANCELLED");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String newStatus, int orderId) async {
    try {
      await _adminOrderService.updateOrderStatus(newStatus, orderId);
      setState(() {
        _pendingPaymentOrders =
            _orderService.getOrdersByStatus("PENDING_PAYMENT");
        _pendingOrders = _orderService.getOrdersByStatus("PENDING");
        _shippingOrders = _orderService.getOrdersByStatus("SHIPPING");
        _deliveredOrders = _orderService.getOrdersByStatus("DELIVERED");
        _canceledOrders = _orderService.getOrdersByStatus("CANCELLED");
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật trạng thái thành công!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  // Chuyển đổi trạng thái từ tiếng Việt -> code
  String normalizeStatus(String rawStatus) {
    switch (rawStatus) {
      case 'Đang chờ thanh toán':
        return 'PENDING_PAYMENT';
      case 'Đang chờ xử lý':
        return 'PENDING';
      case 'Đang giao hàng':
        return 'SHIPPING';
      case 'Đã giao hàng':
        return 'DELIVERED';
      case 'Đã hủy':
        return 'CANCELLED';
      default:
        return rawStatus;
    }
  }

  // Chuyển đổi code -> tiếng Việt
  String mapStatusToText(String code) {
    switch (code) {
      case 'PENDING_PAYMENT':
        return 'Đang chờ thanh toán';
      case 'PENDING':
        return 'Đang chờ xử lý';
      case 'SHIPPING':
        return 'Đang giao hàng';
      case 'DELIVERED':
        return 'Đã giao hàng';
      case 'CANCELLED':
        return 'Đã hủy';
      default:
        return code;
    }
  }

  // Lấy màu sắc cho từng trạng thái
  Color getStatusColor(String status) {
    switch (status) {
      case 'PENDING_PAYMENT':
        return Colors.orange;
      case 'PENDING':
        return Colors.blueGrey;
      case 'SHIPPING':
        return Colors.blue;
      case 'DELIVERED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Danh sách status cho Dropdown
  final List<String> statusOptions = [
    'PENDING_PAYMENT',
    'PENDING',
    'SHIPPING',
    'DELIVERED',
    'CANCELLED',
  ];

  Widget buildStatusFuture(
      Future<List<OrderModel>> futureOrders, String status) {
    return FutureBuilder<List<OrderModel>>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có đơn hàng nào'));
        }

        final orders = snapshot.data!;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return buildOrderItem(order);
          },
        );
      },
    );
  }

  Widget buildOrderItem(OrderModel order) {
    final status = normalizeStatus(
        order.status); // Chuyển trạng thái từ tiếng Việt -> code
    final statusText = mapStatusToText(status); // Chuyển code -> text hiển thị

    return InkWell(
      onTap: () {
        // Xử lý khi nhấn vào Container
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(
                order: order), // Điều hướng đến trang chi tiết đơn hàng
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã đơn hàng: ${order.derivedOrderName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Khách hàng: ${order.receiver}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Tổng tiền: ${order.totalAmount.toString()} VND',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: status, // Code đã normalize
                    items: statusOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          mapStatusToText(option),
                          style: const TextStyle(fontSize: 14),
                        ), // Hiển thị tiếng Việt
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null && value != status) {
                        updateOrderStatus(value, order.id);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Đơn Hàng'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Chờ thanh toán'),
            Tab(text: 'Chờ xử lí'),
            Tab(text: 'Đang giao hàng'),
            Tab(text: 'Đã giao hàng'),
            Tab(text: 'Đã hủy'),
          ],
          tabAlignment: TabAlignment.start,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildStatusFuture(_pendingPaymentOrders, "PENDING_PAYMENT"),
          buildStatusFuture(_pendingOrders, "PENDING"),
          buildStatusFuture(_shippingOrders, "SHIPPING"),
          buildStatusFuture(_deliveredOrders, "DELIVERED"),
          buildStatusFuture(_canceledOrders, "CANCELLED"),
        ],
      ),
    );
  }
}
