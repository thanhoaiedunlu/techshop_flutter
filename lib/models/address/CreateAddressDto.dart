class CreateAddressDto {
  final String address;
  final String numberPhone;
  final String receiver;
  final String? note;
  final int customerId;

  CreateAddressDto({
    required this.address,
    required this.numberPhone,
    required this.receiver,
    this.note,
    required this.customerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'numberPhone': numberPhone,
      'receiver': receiver,
      'note': note,
      'customerId': customerId,
    };
  }
}