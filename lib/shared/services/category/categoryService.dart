import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:http/http.dart' as http;

class CategoryService {

  Future<List<CategoryModel>> getCategories() async {
    const uri = '$baseUrl/api/category/list';
    final url = Uri.parse(uri);
    final headers = {'Content-Type': 'application/json'};
    try {
      final response = await http.get(url, headers: headers);
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        print('Error: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final uri = '$baseUrl/api/category/$categoryId'; // Đường dẫn API xóa sản phẩm
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Xóa thành công
        print('Product deleted successfully');
      } else {
        // Lỗi phía server
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      // Lỗi kết nối hoặc lỗi khác
      throw Exception('Error deleting product: $e');
    }
  }

  Future<bool> editCategory(int id,{
    required String name,
    required String img
    }) async {
    final uri = '$baseUrl/api/category/${id}'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final body = json.encode({
      'name': name,
      'img': img,
    });
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  Future<bool> addCategory({
    required String name,
    required String img
  }) async {
    final uri = '$baseUrl/api/category/'; // Đường dẫn API
    final url = Uri.parse(uri);
    final headers = {
      'Content-Type': 'application/json', // Định dạng body là JSON
    };
    final body = json.encode({
      'name': name,
      'img': img,
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }



}
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo init cho các API
  final categoryService = CategoryService();

  // Gọi phương thức getCategories()
  List<CategoryModel> categories = await categoryService.getCategories();

  // Kiểm tra kết quả trên console
  print('Size: ${categories.length}');

  for (var category in categories) {
    print('Category Name: ${category.name}, Image: ${category.img}');
  }

  // Nếu không dùng giao diện, giữ ứng dụng chạy
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: Text('Check console for output'),
      ),
    ),
  ));
}