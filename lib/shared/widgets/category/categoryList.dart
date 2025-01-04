import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/shared/services/category/categoryService.dart';
import 'package:techshop_flutter/routes/routes.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryService _categoryService = CategoryService();

    return GestureDetector(
      // Detect taps outside the modal to close it
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Transparent background
        body: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            // Prevent tap events from propagating to the background
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.5, // 80% of screen width
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with a close button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20.0),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  // Expanded list of categories
                  Expanded(
                    child: FutureBuilder<List<CategoryModel>>(
                      future: _categoryService.getCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error: ${snapshot.error}')); // Display error
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No categories available.'));
                        } else {
                          // Display the list of categories
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final category = snapshot.data![index];
                              return ListTile(
                                title: Text(category.name),
                                onTap: () {
                                  // Handle category selection
                                  Navigator.of(context)
                                      .pop(); // Close the modal
                                  // Navigate to the selected category's page
                                  Navigator.pushNamed(
                                    context,
                                    Routes.productCategory,
                                    arguments: category,
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
