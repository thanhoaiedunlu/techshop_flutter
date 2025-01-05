import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/shared/services/category/CategoryService.dart';
import 'package:techshop_flutter/shared/services/product/productService.dart';

import '../../../shared/services/expand/ImageUploadService.dart';
import 'ProductManagement.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productPrice;
  final String productCategory;
  final String productImage;
  final String productDetails;

  EditProductScreen({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productCategory,
    required this.productImage,
    required this.productDetails,
  });

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final CategoryService _categoryService = CategoryService();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _detailsController;
  late String imageUrl;
  File? _selectedImage; // Tệp hình ảnh đã chọn
  final ImageUploadService _imageUploadService = ImageUploadService();
  final ProductService _productService = ProductService();
  late List<CategoryModel> categories = [];
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName);
    _priceController = TextEditingController(text: widget.productPrice);
    _detailsController = TextEditingController(text: widget.productDetails);
    imageUrl = widget.productImage;
    selectedCategoryId = widget.productCategory; // Gán danh mục đã chọn
    _fetchCategories();
    print(_detailsController);
  }

  Future<void> _fetchCategories() async {
    final fetchedCategories = await _categoryService.getCategories();
    setState(() {
      categories = fetchedCategories;
    });
  }

  void _updateProduct() {
    _saveProduct();
    Navigator.pop(context); // Quay lại màn hình trước
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
        print("Link :" + uploadedImageUrl);
        setState(() {
          imageUrl = uploadedImageUrl;
        });

        final success = await _productService.editProduct(
          int.parse(widget.productId),
          name: _nameController.text,
          img: imageUrl,
          price: widget.productPrice,
          categoryName: selectedCategoryId.toString(),
          detail: widget.productDetails
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật danh mục thành công!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductManagementScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cập nhật danh mục thất bại')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductManagementScreen()),
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
        imageUrl = widget.productImage;
      });
      final success = await _productService.editProduct(
          int.parse(widget.productId),
          name: _nameController.text,
          img: imageUrl,
          price: _priceController.text,
          categoryName: selectedCategoryId.toString(),
          detail: _detailsController.text
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật sản phẩm thành công!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductManagementScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật sản phẩm thất bại')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductManagementScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa sản phẩm"),
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
                      image: DecorationImage(
                        image: _selectedImage != null
                            ? FileImage(_selectedImage!) // Hiển thị hình ảnh được chọn
                            : NetworkImage(imageUrl) as ImageProvider, // Hiển thị hình ảnh từ URL
                        fit: BoxFit.cover,
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
                    decoration: InputDecoration(labelText: "Tên sản phẩm",  labelStyle: TextStyle(fontSize: 18), // Tăng kích thước label khi không được chọn
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Tăng kích thước khi label nổi lên
                      border: OutlineInputBorder(),),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(labelText: "Giá bán VNĐ",  labelStyle: TextStyle(fontSize: 18), // Tăng kích thước label khi không được chọn
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Tăng kích thước khi label nổi lên
                      border: OutlineInputBorder(),),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: categories.any((category) => category.name.toString() == selectedCategoryId)
                        ? selectedCategoryId
                        : null, // Đặt giá trị null nếu không tìm thấy
                    decoration: InputDecoration(
                      labelText: "Danh mục",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 18), // Tăng kích thước label khi không được chọn
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Tăng kích thước khi label nổi lên
                    ),
                    items: categories
                        .map((category) => DropdownMenuItem<String>(
                      value: category.name.toString(),
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
                      labelStyle: TextStyle(fontSize: 18), // Tăng kích thước label khi không được chọn
                      floatingLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Tăng kích thước khi label nổi lên
                      // Thêm viền nếu cần
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline, // Đảm bảo hỗ trợ nhiều dòng
                    textInputAction: TextInputAction.newline, // Cho phép xuống dòng
                    style: TextStyle(fontSize: 16, fontFamily: 'Roboto'), // Tùy chỉnh hiển thị chữ tiếng Việt
                  ),

                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: Text("Lưu chỉnh sửa"),
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
