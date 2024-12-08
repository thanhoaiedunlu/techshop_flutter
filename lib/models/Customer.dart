class Customer{
  final int id;
  final String fullname;
  final String username;
  final String email;
  final String phone;
  final bool role;
  final int cartId;
  Customer({
    required this.id,
    required this.fullname,
    required this.username,
    required this.email,
    required this.phone,
    required this.role,
    required this.cartId,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      cartId: json['cartId'],
    );
  }
}