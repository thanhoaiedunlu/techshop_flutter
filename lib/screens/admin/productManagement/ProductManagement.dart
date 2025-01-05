import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/ProductModel.dart';
import 'package:techshop_flutter/screens/admin/AdminDashboard.dart';
import 'package:techshop_flutter/screens/admin/productManagement/AddProduct.dart';
import 'package:techshop_flutter/screens/admin/productManagement/EditProduct.dart';

import '../../../../../../shared/services/product/productService.dart';


class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  _ProductManagementScreenState createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final ProductService _productService = ProductService();
  late Future<List<ProductModel>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProducts();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Sản Phẩm"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminApp()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có sản phẩm nào.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2, // Cột chính chứa hình ảnh, tên sản phẩm, giá, hãng
                        child: ListTile(
                          leading: Image.network(
                            product.img,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product.name,
                            maxLines: 1, // Giới hạn số dòng
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${product.price}₫"),
                              Text("${product.categoryName}"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1, // Cột này chiếm 1/5 tổng chiều rộng
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue, size: 20), // Kích thước icon nhỏ hơn
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProductScreen(
                                      productId: product.id.toString(),
                                      productName: product.name,
                                      productPrice: product.price.toString(),
                                      productCategory: product.categoryName,
                                      productImage: product.img,
                                      productDetails: product.detail, // Nếu có
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red, size: 20), // Kích thước icon nhỏ hơn
                              onPressed: () async {
                                try {
                                  await _productService.deleteProduct(product.id);

                                  // Hiển thị thông báo ở giữa màn hình
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop(); // Đóng dialog sau 2 giây
                                      });
                                      return AlertDialog(
                                        content: Text(
                                          'Xóa sản phẩm thành công',
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Đóng dialog ngay lập tức
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  _refreshProducts(); // Cập nhật lại danh sách sản phẩm
                                } catch (e) {
                                  // Hiển thị thông báo lỗi ở giữa màn hình
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop(); // Đóng dialog sau 2 giây
                                      });
                                      return AlertDialog(
                                        content: Text('Lỗi khi xóa sản phẩm: $e'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Đóng dialog ngay lập tức
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: ProductManagementScreen(),
));
