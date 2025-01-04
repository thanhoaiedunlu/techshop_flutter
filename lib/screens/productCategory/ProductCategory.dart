import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/ProductModel.dart';
import 'package:techshop_flutter/shared/services/product/productService.dart';
import 'package:techshop_flutter/shared/widgets/product/productList.dart';

class ProductByCategoryScreen extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductByCategoryScreen({
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductService _productService = ProductService();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productService.getProductsByCategoryId(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products available in this category.'));
          } else {
            final products = snapshot.data!;
            return ProductListView(products: products);
          }
        },
      ),
    );
  }
}
