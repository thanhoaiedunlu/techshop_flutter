import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techshop_flutter/shared/constant/constants.dart';
import '../../../models/Revenue.dart';
class ChartService {
  // Hàm gọi API và lấy dữ liệu
  Future<List<Revenue>> getRevenueData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/order/revenue'));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData
            .map((item) => Revenue.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
