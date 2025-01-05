class Revenue {
  final int month;
  final int revenue;

  Revenue({required this.month, required this.revenue});

  // Hàm tạo đối tượng Revenue từ dữ liệu JSON
  factory Revenue.fromJson(Map<String, dynamic> json) {
    return Revenue(
      month: (json['month'] is int) ? json['month'] : (json['month'] as double).toInt(),
      revenue: (json['revenue'] is int) ? json['revenue'] : (json['revenue'] as double).toInt(),
    );
  }
  // Hàm chuyển đổi đối tượng Revenue thành Map
  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'revenue': revenue,
    };
  }
}
