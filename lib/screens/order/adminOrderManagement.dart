import 'package:flutter/material.dart';
import '../../models/OrderModel.dart';
import '../../shared/services/order/adminOrderService.dart';

class AdminOrderManagement extends StatefulWidget {
  @override
  _AdminOrderManagementState createState() => _AdminOrderManagementState();
}

class _AdminOrderManagementState extends State<AdminOrderManagement> {
  final AdminOrderService _adminOrderService = AdminOrderService();
  late Future<List<OrderModel>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _futureOrders = _adminOrderService.getOrders(); // Lấy danh sách đơn hàng
  }

  // Lấy màu sắc trạng thái
  Color getStatusColor(String status) {
    switch (status) {
      case 'Đang giao':
        return Colors.blue;
      case 'Đã giao':
        return Colors.green;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String status, int orderId) async {
    try {
      await _adminOrderService.updateOrderStatus(status, orderId);
      setState(() {
        _futureOrders = _adminOrderService.getOrders();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật trạng thái thành công!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Biểu tượng mũi tên
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          }
        ),
        title: Text('Quản Lý Đơn Hàng'),
      ),


      body: FutureBuilder<List<OrderModel>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              // Lấy dữ liệu
              final orderName = order.derivedOrderName; // Tên đơn hàng từ sản phẩm
              final receiver = order.receiver;         // Người nhận
              final status = order.status;             // Trạng thái đơn hàng

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tên đơn hàng: $orderName',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Khách hàng: $receiver',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tổng tiền: ${order.totalAmount.toString()} VND',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Trạng thái: ', style: TextStyle(fontSize: 14)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: getStatusColor(status), // Lấy màu theo trạng thái
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: ['Đang giao', 'Đã giao', 'Đã hủy'].contains(status) ? status : 'Đang giao',
                          items: [
                            DropdownMenuItem(value: 'Đang giao', child: Text('Đang giao')),
                            DropdownMenuItem(value: 'Đã giao', child: Text('Đã giao')),
                            DropdownMenuItem(value: 'Đã hủy', child: Text('Đã hủy')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              updateOrderStatus(value, order.id); // Cập nhật trạng thái
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );


        },
      ),
    );
  }
}
