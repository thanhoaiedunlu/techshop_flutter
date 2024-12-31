import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/OrderModel.dart';
import '../../constant/constants.dart';

class OrderService {
  // Hàm lấy danh sách đơn hàng
  Future<List<OrderModel>> getOrders() async {
    final String url = '$baseUrl/api/order/list'; // Endpoint API
    final Uri uri = Uri.parse(url);
    print(url);
    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      // Kiểm tra mã trạng thái phản hồi
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Chuyển đổi dữ liệu JSON thành danh sách OrderModel
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }
}
