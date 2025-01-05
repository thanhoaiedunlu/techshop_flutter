import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:techshop_flutter/models/ProductModel.dart';
import 'package:techshop_flutter/routes/routes.dart';
import 'package:techshop_flutter/shared/helper/BottomNavHelper.dart';
import 'package:techshop_flutter/shared/services/cartItem/CartItemService.dart';
import 'package:techshop_flutter/shared/utils/shared_preferences.dart';
import 'package:techshop_flutter/shared/widgets/navigateBar/bottom.dart';

// Sửa import cho đúng với file chứa CustomBottomNavigationBar (nếu cần)

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
            leading: Image.network(product.img, width: 60, fit: BoxFit.cover),
            title: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${NumberFormat.currency(locale: 'vi', symbol: '₫').format(product.price)} '),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () async {
                final cartId =
                    await SharedPreferencesHelper.getCartIdByUserLogin();
                if (cartId != null) {
                  final success = await CartItemService()
                      .addCartItem(cartId, product.id, 1);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Added ${product.name} to cart!'
                            : 'Failed to add ${product.name} to cart.',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  if (success) {
                    // Tìm widget cha (hoặc ancestor) là CustomBottomNavigationBar
                    await BottomNavHelper.reloadCartBadge();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to retrieve cart ID. Please log in.'),
                    ),
                  );
                }
              },
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.productDetail,
                arguments: product.id,
              );
            },
          ),
        );
      },
    );
  }
}
