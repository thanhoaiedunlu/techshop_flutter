class CategoryModel {
  final int id; // Đổi thành int vì API trả về số nguyên
  final String name;
  final String img;

  CategoryModel({
    required this.id,
    required this.name,
    required this.img,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'], // API trả về số nguyên
      name: json['name'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
    };
  }
}
