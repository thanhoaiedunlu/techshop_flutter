import 'dart:convert';

import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:http/http.dart' as http;

class CategoryService {

  Future<List<CategoryModel>> getCategories() async {
    const uri = '$baseUrl/api/category/list'; // Đường dẫn API
    final url = Uri.parse(uri);
    print(url);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<CategoryModel> products =
        data.map((e) => CategoryModel.fromJson(e)).toList();
        return products;
      } else {
        return [];
      }
    } catch (e) {
      return []; // Trả về danh sách rỗng trong trường hợp lỗi
    }
  }
}