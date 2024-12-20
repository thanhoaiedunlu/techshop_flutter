import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/ProductModel.dart';
import 'package:techshop_flutter/screens/detailProduct/DetailProduct.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListView({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Image.network(product.img),
            title: Text(
              product.name,
              maxLines: 1, // Giới hạn số dòng
              overflow: TextOverflow.ellipsis, // Hiển thị dấu "..." nếu vượt quá
              style: const TextStyle(fontWeight: FontWeight.bold), // Thêm tùy chọn kiểu chữ nếu muốn
            ),
            subtitle: Text('${product.price} VND'),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart), // Biểu tượng giỏ hàng
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to cart!')),
                );
              },
            ),
              onTap: () {
                // Điều hướng đến màn hình chi tiết sản phẩm và truyền productId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProduct(productId: product.id),
                  ),
                );
              }

          ),
        );
      },
    );
  }
}
