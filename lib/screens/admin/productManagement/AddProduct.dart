import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:techshop_flutter/screens/admin/productManagement/ProductManagement.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/shared/services/category/CategoryService.dart';
import 'package:techshop_flutter/shared/services/product/productService.dart';

import '../../../shared/services/expand/ImageUploadService.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final CategoryService _categoryService = CategoryService();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _detailsController;
  String imageUrl = "";
  File? _selectedImage; // Tệp hình ảnh đã chọn
  final ImageUploadService _imageUploadService = ImageUploadService();
  final ProductService _productService = ProductService();
  late List<CategoryModel> categories = [];
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _detailsController = TextEditingController();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final fetchedCategories = await _categoryService.getCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_selectedImage != null) {
      try {
        final multipartFile = await MultipartFile.fromPath(
          'file', // Tên trường file trong API
          _selectedImage!.path,
        );
        final uploadedImageUrl = await _imageUploadService.uploadImage(multipartFile);
        print(uploadedImageUrl);
        setState(() {
          imageUrl = uploadedImageUrl;
        });

        final success = await _productService.addProduct(
          name: _nameController.text,
          img: imageUrl,
          price: _priceController.text,
          categoryName: selectedCategoryId.toString(),
          detail: _detailsController.text,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm sản phẩm thành công!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductManagementScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thêm sản phẩm thất bại')),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải ảnh lên: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn ảnh sản phẩm!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm sản phẩm"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ảnh sản phẩm
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: _selectedImage != null
                          ? DecorationImage(
                        image: FileImage(_selectedImage!), // Hiển thị hình ảnh được chọn
                        fit: BoxFit.cover,
                      )
                          : null,
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
                      icon: Icon(Icons.add_a_photo, color: Colors.blue),
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
                      labelText: "Tên sản phẩm",
                      labelStyle: TextStyle(fontSize: 18),
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: "Giá bán VNĐ",
                      labelStyle: TextStyle(fontSize: 18),
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: "Danh mục",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 18),
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _detailsController,
                    decoration: InputDecoration(
                      labelText: "Chi tiết sản phẩm",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 18),
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text("Thêm sản phẩm"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.blue,
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
