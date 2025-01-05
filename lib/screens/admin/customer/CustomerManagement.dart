import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CustomerModel.dart';
import 'package:techshop_flutter/screens/admin/AdminDashboard.dart';

import '../../../shared/services/customer/customerService.dart';
import 'EditCustomer.dart';

class CustomerManagementScreen extends StatefulWidget {
  @override
  _CustomerManagementScreenState createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  final CustomerService _customerService = CustomerService();
  late Future<List<CustomerModel>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture = _customerService.getCustomers();
  }

  void _refreshCustomers() {
    setState(() {
      _customersFuture = _customerService.getCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Khách Hàng"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminApp()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () {
              // Xử lý thêm khách hàng mới
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CustomerModel>>(
        future: _customersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có khách hàng nào.'));
          } else {
            final customers = snapshot.data!;
            return ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(customer.username,
                      maxLines: 1, // Giới hạn số dòng
                      overflow: TextOverflow.ellipsis, ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${customer.email}"),
                        Text("Phone: ${customer.phone}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCustomerScreen(
                                  customerId: customer.id.toString(),
                                  customerUsername: customer.username,
                                  customerEmail: customer.email,
                                  customerPhone: customer.phone,
                                ),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await _customerService.deleteCustomer(customer.id);

                              // Hiển thị thông báo ở giữa màn hình
                              showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop(); // Đóng dialog sau 2 giây
                                  });
                                  return AlertDialog(
                                    content: Text('Xóa khách hàng thành công', textAlign: TextAlign.center,),
                                    actions: [TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Đóng dialog ngay lập tức
                                      },
                                      child: Text('OK'),
                                    ),],
                                  );
                                },
                              );

                              _refreshCustomers(); // Cập nhật lại danh sách khách hàng
                            } catch (e) {
                              // Hiển thị thông báo lỗi ở giữa màn hình
                              showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop(); // Đóng dialog sau 2 giây
                                  });
                                  return AlertDialog(
                                    content: Text('Lỗi khi xóa khách hàng: $e'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Đóng dialog ngay lập tức
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: CustomerManagementScreen(),
));
