import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../constant/constants.dart';

class ImageUploadService {
  Future<String> uploadImage(http.MultipartFile file) async {
    final uri = '$baseUrl/api/cloudinary/upload'; // Đường dẫn API
    final url = Uri.parse(uri);

    try {
      // Tạo yêu cầu multipart
      final request = http.MultipartRequest('POST', url);

      // Thêm file vào yêu cầu
      request.files.add(file);

      // Gửi yêu cầu và chờ phản hồi
      final response = await request.send();

      // Đọc nội dung phản hồi
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> data = json.decode(responseBody);

        // Trích xuất URL từ dữ liệu phản hồi
        if (data.containsKey('url')) {
          return data['url'];
        } else {
          throw Exception('URL không tồn tại trong phản hồi');
        }
      } else {
        throw Exception(
            'Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}

extension MultipartFileExtensions on http.MultipartFile {
  Future<List<int>> readAsBytes() async {
    if (this.filename != null && this.finalize() != null) {
      // Đọc dữ liệu từ finalize stream
      final bytes = await this.finalize().toBytes();
      return bytes;
    } else {
      throw Exception('Không thể đọc nội dung từ MultipartFile');
    }
  }
}
