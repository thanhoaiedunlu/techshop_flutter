import 'package:flutter/material.dart';

import '../../models/ProductModel.dart';
import '../../shared/services/product/productService.dart';
import '../../shared/widgets/navigateBar/bottom.dart';
import '../../shared/widgets/product/productList.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  int _currentIndex = 0;
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm Kiếm Sản Phẩm'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _productService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No products available.'));
                } else {
                  final filteredProducts = snapshot.data!.where((product) {
                    return product.name.toLowerCase().contains(_searchQuery);
                  }).toList();

                  return ProductListView(products: filteredProducts);
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
