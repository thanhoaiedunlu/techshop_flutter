class CategoryModel {
  late final String id;
  late final String name;
  late final String img;

  CategoryModel({
    required this.id,
    required this.name,
    required this.img,
  });

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['img'] = img;
    return data;
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      img: map['img'],
    );
  }
}
