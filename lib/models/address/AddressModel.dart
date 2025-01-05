class AddressModel {
  final int id;
  final String address;
  final String numberPhone;
  final String receiver;
  final String? note;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.address,
    required this.numberPhone,
    required this.receiver,
    this.note,
    required this.isDefault,
  });

  // Factory constructor để tạo AddressModel từ JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      address: json['address'],
      numberPhone: json['numberPhone'],
      receiver: json['receiver'],
      note: json['note'],
      isDefault: json['default'], // Sửa từ 'isDefault' thành 'default'
    );
  }

  // Phương thức để chuyển đổi AddressModel thành Map (hoặc JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'address': address,
      'numberPhone': numberPhone,
      'receiver': receiver,
      'note': note,
      'default': isDefault, // Sửa từ 'isDefault' thành 'default'
    };
  }

  // Factory constructor để tạo AddressModel từ Map (nếu cần dùng)
  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'],
      address: map['address'],
      numberPhone: map['numberPhone'],
      receiver: map['receiver'],
      note: map['note'],
      isDefault: map['default'], // Sửa từ 'isDefault' thành 'default'
    );
  }
}
