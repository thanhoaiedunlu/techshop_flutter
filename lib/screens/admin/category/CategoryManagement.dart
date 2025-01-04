import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/screens/admin/category/AddCategory.dart';

import '../../../shared/services/category/categoryService.dart';
import '../AdminDashboard.dart';
import 'EditCategory.dart';

class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final CategoryService _categoryService = CategoryService();
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.getCategories();
  }

  void _refreshCategories() {
    setState(() {
      _categoriesFuture = _categoryService.getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Danh Mục"),
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
                MaterialPageRoute(builder: (context) => AddCategoryScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có danh mục nào.'));
          } else {
            final categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(
                      category.img,
                      width: 75,
                      height: 75,

                    ),
                    title: Text(category.name,
                      maxLines: 1, // Giới hạn số dòng
                      overflow: TextOverflow.ellipsis, ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCategoryScreen(
                                  categoryId: category.id.toString(),
                                  categoryName: category.name,
                                  categoryImage: category.img,
                                ),
                              ),
                            );
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await _categoryService.deleteCategory(category.id as int);

                              // Hiển thị thông báo ở giữa màn hình
                              showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop(); // Đóng dialog sau 2 giây
                                  });
                                  return AlertDialog(
                                    content: Text('Xóa danh mục thành công', textAlign: TextAlign.center,),
                                    actions: [TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Đóng dialog ngay lập tức
                                      },
                                      child: Text('OK'),
                                    ),],
                                  );
                                },
                              );

                              _refreshCategories(); // Cập nhật lại danh sách danh mục
                            } catch (e) {
                              // Hiển thị thông báo lỗi ở giữa màn hình
                              showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop(); // Đóng dialog sau 2 giây
                                  });
                                  return AlertDialog(
                                    content: Text('Lỗi khi xóa danh mục: $e'),
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
  home: CategoryManagementScreen(),
));
