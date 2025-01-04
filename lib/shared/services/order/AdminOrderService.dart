import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/OrderModel.dart';
import '../../constant/constants.dart';

class AdminOrderService {
  // Lấy danh sách đơn hàng
  Future<List<OrderModel>> getOrders() async {
    final url = Uri.parse('$baseUrl/api/order/list');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> data = json.decode(decodedResponse);

        // Ánh xạ JSON thành danh sách OrderModel
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Lỗi tải danh sách đơn hàng: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Không thể tải danh sách đơn hàng: $error');
    }
  }

  // Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String status, int orderId) async {
    final url = Uri.parse('$baseUrl/api/order/status/${Uri.encodeComponent(status)}&&$orderId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Lỗi cập nhật trạng thái: ${response.body}');
      }
    } catch (error) {
      throw Exception('Không thể cập nhật trạng thái: $error');
    }
  }
}
