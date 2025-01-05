import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/src/multipart_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:techshop_flutter/screens/admin/category/CategoryManagement.dart';
import 'package:techshop_flutter/shared/services/category/CategoryService.dart';
import 'package:techshop_flutter/shared/services/expand/ImageUploadService.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryImage;

  EditCategoryScreen({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController _nameController;
  File? _selectedImage; // Tệp hình ảnh đã chọn
  String imageUrl = ''; // URL ảnh hiện tại
  final ImageUploadService _imageUploadService = ImageUploadService();
  final CategoryService _categoryService = CategoryService();


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.categoryName);
    imageUrl = widget.categoryImage;


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

  Future<void> _saveCategory() async {
    if (_selectedImage != null) {
      try {
        final multipartFile = await MultipartFile.fromPath(
          'file', // Tên trường file trong API
          _selectedImage!.path,
        );
        final uploadedImageUrl = await _imageUploadService.uploadImage(multipartFile);
        print("Link :" + uploadedImageUrl);
        setState(() {
          imageUrl = uploadedImageUrl;
        });

        final success = await _categoryService.editCategory(
          int.parse(widget.categoryId),
          name: _nameController.text,
          img: imageUrl,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật danh mục thành công!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật danh mục thất bại')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải ảnh lên: $e')),
        );
      }
    } else {
      setState(() {
        imageUrl = widget.categoryImage;
      });

      final success = await _categoryService.editCategory(
        int.parse(widget.categoryId),
        name: _nameController.text,
        img: imageUrl,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật danh mục thành công!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật danh mục thất bại')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoryManagementScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa danh mục"),
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
                      image: DecorationImage(
                        image: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : NetworkImage(imageUrl) as ImageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
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
                      labelStyle: TextStyle(fontSize: 18), // Tăng kích thước label khi không được chọn
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Tăng kích thước khi label nổi lên
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveCategory,
                    child: Text("Lưu chỉnh sửa"),
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
