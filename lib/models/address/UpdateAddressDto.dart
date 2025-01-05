class UpdateAddressDto {
  final String address;
  final String numberPhone;
  final String receiver;
  final String? note;

  UpdateAddressDto({
    required this.address,
    required this.numberPhone,
    required this.receiver,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'number_phone': numberPhone,
      'receiver': receiver,
      'note': note,
    };
  }
}
