import 'package:intl/intl.dart';

class ProductModel {
  late final int id;
  late final String name;
  late final String img;
  late final int price;
  late final String categoryName;
  late final String detail;

  ProductModel({
    required this.id,
    required this.name,
    required this.img,
    required this.price,
    required this.categoryName,
    required this.detail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      price: json['price'],
      categoryName: json['categoryName'],
      detail: json['detail'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'price': price,
      'categoryName': categoryName,
      'detail': detail,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      img: map['img'],
      price: map['price'],
      categoryName: map['categoryName'],
      detail: map['detail'],
    );
  }

  // Getter để định dạng giá thành VND
  String get formattedPrice {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'vn₫');
    return formatter.format(price);
  }
}