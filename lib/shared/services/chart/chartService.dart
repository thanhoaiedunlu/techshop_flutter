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
  // Tạo dữ liệu mẫu
  // Future<List<Revenue>> getRevenueData() async {
  //   return Future.delayed(
  //     const Duration(seconds: 1),
  //         () => [
  //       Revenue(month: 1, revenue: 10000000),
  //       Revenue(month: 2, revenue: 15000000),
  //       Revenue(month: 3, revenue: 20000000),
  //       Revenue(month: 4, revenue: 25000000),
  //       Revenue(month: 5, revenue: 30000000),
  //       Revenue(month: 6, revenue: 50000000),
  //       Revenue(month: 7, revenue: 45000000),
  //       Revenue(month: 8, revenue: 40000000),
  //       Revenue(month: 9, revenue: 60000000),
  //       Revenue(month: 10, revenue: 70000000),
  //       Revenue(month: 11, revenue: 80000000),
  //       Revenue(month: 12, revenue: 90000000),
  //     ],
  //   );
  // }
}
