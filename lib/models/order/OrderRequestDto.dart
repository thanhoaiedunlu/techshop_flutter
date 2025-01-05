class OrderDetailRequestDto {
  final int productId;
  final int quantity;

  OrderDetailRequestDto({
    required this.productId,
    required this.quantity,
  });

  // Hàm chuyển đối tượng này sang Map để encode JSON
  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "quantity": quantity,
    };
  }
}

class OrderRequestDto {
  final int customerId;
  final int totalAmount;
  final String address;
  final String numberPhone;
  final String receiver;
  final List<OrderDetailRequestDto> orderDetails;

  OrderRequestDto({
    required this.customerId,
    required this.totalAmount,
    required this.address,
    required this.numberPhone,
    required this.receiver,
    required this.orderDetails,
  });

  // Chuyển đối tượng này sang Map để encode JSON
  Map<String, dynamic> toJson() {
    return {
      "customerId": customerId,
      "totalAmount": totalAmount,
      "address": address,
      "numberPhone": numberPhone,
      // status và paymentMethod sẽ được set từ @RequestParam bên server
      // => ta không cần truyền thẳng trong body (trừ khi bạn muốn ghi đè)
      "receiver": receiver,
      "orderDetails": orderDetails.map((e) => e.toJson()).toList(),
    };
  }
}
