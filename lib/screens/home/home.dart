import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/ProductModel.dart';
import 'package:techshop_flutter/routes/routes.dart';
import 'package:techshop_flutter/shared/services/product/productService.dart';
import 'package:techshop_flutter/shared/widgets/category/categoryList.dart';
import 'package:techshop_flutter/shared/widgets/navigateBar/bottom.dart';
import 'package:techshop_flutter/shared/widgets/navigateBar/top.dart';
import 'package:techshop_flutter/shared/widgets/product/productList.dart';

import '../seachProduct/ProductSearch.dart'; // Đảm bảo đã import model Product

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tạo một instance của ProductService
  final ProductService _productService = ProductService();
  int _currentIndex = 0;
  TextEditingController _searchController = TextEditingController();
  bool _isCategoryVisible = false; // Để điều khiển hiển thị danh mục
  bool _isSearching = false;
  void _toggleSearch() {
    Navigator.pushNamed(context, Routes.productSearch);
  }


  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Để làm tối màn hình dưới
      builder: (BuildContext context) {
        return CategoryListView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopNavigationBar(
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchPressed: _toggleSearch,
        onCategoryPressed: _showCategoryModal,
      ),
      body: Column(
        children: [
          Image.asset('assets/images/banner.jpg'),
          // Đảm bảo đã có file banner.jpg trong thư mục assets
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _productService.getProducts(), // Gọi API bất đồng bộ
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                      CircularProgressIndicator()); // Hiển thị loading khi đang chờ dữ liệu
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          'Error: ${snapshot.error}')); // Hiển thị lỗi nếu có
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child:
                      Text('No products available.')); // Không có sản phẩm
                } else {
                  // Dữ liệu đã sẵn sàng, hiển thị danh sách sản phẩm
                  return ProductListView(products: snapshot.data!);
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      ), // Navigation bar tái sử dụng
    );
  }
}
