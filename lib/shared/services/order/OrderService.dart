import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techshop_flutter/models/order/OrderRequestDto.dart';
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
        throw Exception(
            'Failed to load orders. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // Hàm tạo đơn hàng
  static Future<int?> saveOrder(
    String paymentMethod, // "COD", "MOMO", ...
    String status, // "CREATED", "SHIPPING", ...
    OrderRequestDto dto,
  ) async {
    try {
      // Tạo URI kèm query string
      final uri = Uri.parse(
        '$baseUrl/api/order?method=$paymentMethod&status=$status',
      );

      // Chuyển body sang JSON
      final bodyJson = jsonEncode(dto.toJson());

      // Thực hiện POST
      print(uri);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: bodyJson,
      );

      // Kiểm tra mã trạng thái
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Server trả về ID (int) -> parse sang int
        return int.tryParse(response.body);
      } else {
        // Thất bại -> in ra log (hoặc throw exception tuỳ ý)
        print(
            'Error saving order. Code: ${response.statusCode}, Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
