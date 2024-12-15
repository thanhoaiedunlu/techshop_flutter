import 'package:flutter/material.dart';

class CustomTopNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchPressed;
  final VoidCallback onCategoryPressed;

  const CustomTopNavigationBar({
    Key? key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchPressed,
    required this.onCategoryPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearching
          ? TextField(
              controller: searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm...',
                border: InputBorder.none,
              ),
            )
          : const Center(child: Text('Trang chủ')),
      leading: IconButton(
        icon: const Icon(Icons.category),
        onPressed: onCategoryPressed,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: onSearchPressed,
        ),
      ],
    );
  }
}
