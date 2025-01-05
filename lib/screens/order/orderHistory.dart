import 'package:flutter/material.dart';
import '../../models/OrderModel.dart';
import '../../routes/routes.dart';
import '../../shared/constant/constants.dart';
import '../../shared/services/order/OrderService.dart';
import '../../shared/utils/shared_preferences.dart';

class OrderHistoryScreen extends StatefulWidget {
  final int customerId;
  const OrderHistoryScreen({super.key, required this.customerId});
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  final OrderService _orderService = OrderService();
  late Future<List<OrderModel>> _futureOrders;
  late TabController _tabController;
  String? selectedStatus = 'Tất cả'; // Lưu trạng thái lọc

  @override
  void initState() {
    super.initState();
    _futureOrders = _orderService.getOrders(widget.customerId); // Lấy danh sách đơn hàng từ API
    _tabController = TabController(length: 5, vsync: this); // Tạo controller cho TabBar
    _tabController.addListener(() {
      // Cập nhật trạng thái lọc khi tab thay đổi
      setState(() {
        selectedStatus = _getStatusFromTabIndex(_tabController.index);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Giải phóng tài nguyên TabController
    super.dispose();
  }

  String? _getStatusFromTabIndex(int index) {
    switch (index) {
      case 0:
        return 'Tất cả';
      case 1:
        return 'Đang xử lý';
      case 2:
        return 'Đang giao';
      case 3:
        return 'Đã giao';
      case 4:
        return 'Đã hủy';
      default:
        return 'Tất cả';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Giảm chiều cao của AppBar
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryColor,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Lịch Sử Mua Hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                // TabBar phần quan trọng
                Padding(
                  padding: const EdgeInsets.only(top: 8.0), // Điều chỉnh khoảng cách giữa phần trên và TabBar
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    unselectedLabelColor: AppColors.textMutedColor,
                    indicatorColor: AppColors.primaryColor,
                    indicatorWeight: 3.0,
                    tabs: const [
                      Tab(text: 'Tất cả'),
                      Tab(text: 'Đang xử lý'),
                      Tab(text: 'Đang giao'),
                      Tab(text: 'Đã giao'),
                      Tab(text: 'Đã hủy'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.primaryColor,
      body: FutureBuilder<List<OrderModel>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Hiển thị khi đang tải dữ liệu
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lỗi: ${snapshot.error}',
                style: TextStyle(color: Colors.black),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Không có đơn hàng nào',
                style: TextStyle(color: AppColors.textMutedColor),
              ),
            );
          }

          final orders = snapshot.data!;
          return TabBarView(
            controller: _tabController, // Kết nối TabBarView với TabController
            children: [
              buildOrderList(orders, null), // Hiển thị tất cả đơn hàng
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
    // Lọc danh sách đơn hàng theo trạng thái
    final filteredOrders = statusFilter == null
        ? orders
        : orders.where((order) => order.status == statusFilter).toList();

    if (filteredOrders.isEmpty) {
      return const Center(
        child: Text('Không có đơn hàng nào'),
      );
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return GestureDetector(
          onTap: () async {
            // Pass order object to the next screen via Navigator
            Navigator.pushNamed(
              context,
              Routes.orderHistoryDetail,
              arguments: order, // Passing order as an argument
            );
          },
          child: Card(
            color: AppColors.backgroundLightColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Image.network(
                order.orderDetails.first.productResponseDTO.img ?? '',
                width: 70,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
              title: Text(
                order.derivedOrderName ?? 'Không có tên',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'Khách hàng: ${order.receiver ?? 'Không có tên'}\n'
                    'Tổng tiền: ${order.totalAmount ?? 0}đ',
                style: TextStyle(color: AppColors.textMutedColor),
              ),
              trailing: Text(
                order.status ?? '',
                style: TextStyle(
                  color: getStatusColor(order.status ?? ''),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Đang xử lý':
        return AppColors.statusProcessing;
      case 'Đang giao':
        return AppColors.statusDelivered;
      case 'Đã hủy':
        return AppColors.statusCancelled;
      default:
        return AppColors.statusDefault;
    }
  }
}

