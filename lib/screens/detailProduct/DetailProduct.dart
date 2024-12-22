import 'package:flutter/material.dart';
import '../../models/ProductModel.dart';
import '../../shared/services/product/productService.dart';

class DetailProduct extends StatefulWidget {
  final int productId;

  const DetailProduct({Key? key, required this.productId}) : super(key: key);

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late Future<ProductModel> _productDetail;

  @override
  void initState() {
    super.initState();
    _productDetail = _fetchProductDetail(widget.productId);
  }

  Future<ProductModel> _fetchProductDetail(int productId) async {
    final productService = ProductService();
    return await productService.getProductDetail(productId.toString());  // Chuyển đổi id sang String nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm"),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<ProductModel>(
        future: _productDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No details available.'));
          } else {
            final product = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.network(
                      product.img, // Hình ảnh sản phẩm từ API
                      height: 200,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    product.name, // Tên sản phẩm
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Danh Mục: ${product.categoryName}", // Danh mục sản phẩm
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Giá: ${product.price} VND", // Giá sản phẩm
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    product.detail, // Mô tả sản phẩm
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic thêm vào giỏ hàng
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(250, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Thêm vào giỏ hàng",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
