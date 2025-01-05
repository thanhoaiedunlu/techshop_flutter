import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/src/multipart_file.dart';
import 'package:techshop_flutter/screens/admin/category/CategoryManagement.dart';
import 'package:techshop_flutter/shared/services/category/CategoryService.dart';
import 'package:techshop_flutter/shared/services/expand/ImageUploadService.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late TextEditingController _nameController;
  File? _selectedImage; // Tệp hình ảnh đã chọn
  String imageUrl = ''; // URL ảnh hiện tại
  final ImageUploadService _imageUploadService = ImageUploadService();
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _addCategory() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập tên danh mục')),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn một hình ảnh')),
      );
      return;
    }

    try {
      // Tải hình ảnh lên trước
      final multipartFile = await MultipartFile.fromPath(
        'file', // Tên trường file trong API
        _selectedImage!.path,
      );
      final uploadedImageUrl = await _imageUploadService.uploadImage(multipartFile);
      print("Link hình ảnh: $uploadedImageUrl");

      // Gửi thông tin danh mục mới lên API
      final success = await _categoryService.addCategory(
        name: _nameController.text,
        img: uploadedImageUrl,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm danh mục thành công!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thêm danh mục thất bại')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm danh mục: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm danh mục"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hiển thị ảnh danh mục
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Màu nền mặc định nếu không có ảnh
                      image: _selectedImage != null
                          ? DecorationImage(
                        image: FileImage(_selectedImage!),
                        fit: BoxFit.contain,
                      )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Center(
                      child: Text(
                        'Chưa có hình ảnh',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.yellow,
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      iconSize: 30,
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Tên danh mục",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _addCategory,
                    child: Text("Thêm danh mục"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
