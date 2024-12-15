import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:techshop_flutter/models/CategoryModel.dart';
import 'package:techshop_flutter/shared/services/category/categoryService.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> with TickerProviderStateMixin {
  final CategoryService _categoryService = CategoryService();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // Bắt đầu từ bên trái
      end: const Offset(0, 0),    // Kết thúc tại vị trí bình thường
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Kích hoạt animation khi widget được xây dựng
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Đóng modal khi bấm bên ngoài
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Làm mờ nền
        child: Container(
          color: Colors.black.withOpacity(0.5), // Làm tối nền
          child: Align(
            alignment: Alignment.centerLeft,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: screenWidth * 2 / 3, // Chiếm 2/3 màn hình
                height: double.infinity,
                color: Colors.white,
                child: FutureBuilder<List<CategoryModel>>(
                  future: _categoryService.getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No categories available.'));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data![index].name),
                            onTap: () {
                              // Xử lý khi chọn danh mục
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
