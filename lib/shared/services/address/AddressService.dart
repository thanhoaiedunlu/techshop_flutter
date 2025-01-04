import 'dart:convert';

import 'package:techshop_flutter/models/address/AddressModel.dart';
import 'package:techshop_flutter/models/address/CreateAddressDto.dart';
import 'package:techshop_flutter/models/address/UpdateAddressDto.dart';
import 'package:techshop_flutter/shared/constant/constants.dart';
import 'package:http/http.dart' as http;

class AddressService {
  Future<List<AddressModel>?> getAllAddresses() async {
    final url = Uri.parse('$baseUrl/api/address/');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((item) => AddressModel.fromJson(item)).toList();
    } else {
      // Xử lý lỗi (có thể log hoặc ném ngoại lệ)
      return null;
    }
  }

  Future<List<AddressModel>?> getAddressesByCustomerId(int customerId) async {
    final url = Uri.parse('$baseUrl/api/address/customer/$customerId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((item) => AddressModel.fromJson(item)).toList();
    } else {
      // Xử lý lỗi
      return null;
    }
  }

  Future<AddressModel?> getAddress(int id) async {
    final url = Uri.parse('$baseUrl/api/address/$id');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      return AddressModel.fromJson(data);
    } else {
      // Xử lý lỗi
      return null;
    }
  }

  // Đảm bảo hàm setDefaultAddress yêu cầu cả customerId và addressId
  Future<bool> setDefaultAddress(int customerId, int addressId) async {
    final url =
        Uri.parse('$baseUrl/api/address/default/$customerId/$addressId');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final bool result = jsonDecode(utf8.decode(response.bodyBytes));
        return result;
      } else {
        // Xử lý lỗi
        return false;
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Error setting default address: $e');
      return false;
    }
  }

// Tạo địa chỉ mới
  Future<AddressModel?> createAddress(CreateAddressDto dto) async {
    final url = Uri.parse('$baseUrl/api/address/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toMap()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        return AddressModel.fromJson(data);
      } else {
        // Xử lý lỗi
        return null;
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Error creating address: $e');
      return null;
    }
  }

  // Cập nhật địa chỉ
  Future<AddressModel?> updateAddress(int id, UpdateAddressDto dto) async {
    final url = Uri.parse('$baseUrl/api/address/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto.toMap()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(utf8.decode(response.bodyBytes));
        return AddressModel.fromJson(data);
      } else {
        // Xử lý lỗi
        return null;
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Error updating address: $e');
      return null;
    }
  }

  // Xóa địa chỉ
  Future<bool> deleteAddress(int id) async {
    final url = Uri.parse('$baseUrl/api/address/$id');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      // Xử lý ngoại lệ
      print('Error deleting address: $e');
      return false;
    }
  }

  Future<AddressModel> getAddressByCustomerIdAndIsDefault(
      int customerId) async {
    final url = Uri.parse('$baseUrl/api/address/default/$customerId');
    print(url);
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      return AddressModel.fromJson(data);
    } else {
      // Xử lý lỗi
      throw Exception('Failed to load address');
    }
  }
}
