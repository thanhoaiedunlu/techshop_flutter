class CustomerModel{
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final bool role;
  final int cartId;
  CustomerModel({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.cartId,
  });
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      cartId: json['cartId'],
    );
  }
  // Chuyển đối tượng User thành Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'email': email,
      'phone': phone,
      'role': role,
      'cartId': cartId,
    };
  }
  // Khởi tạo đối tượng User từ Map (dữ liệu JSON)
  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      fullname: map['fullname'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      cartId: map['cartId'],
    );
}
}