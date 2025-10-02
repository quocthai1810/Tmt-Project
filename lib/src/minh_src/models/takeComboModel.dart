class ComboModel {
  final int maDoAn;
  final int maHeThong;
  final String tenCombo;
  final String moTa;
  final int gia;
  final String hinhAnh;
  int quantity;

  ComboModel({
    required this.maDoAn,
    required this.maHeThong,
    required this.tenCombo,
    required this.moTa,
    required this.gia,
    required this.hinhAnh,
    this.quantity = 1,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      maDoAn: json['ma_do_an'] != null ? json['ma_do_an'] as int : 0,
      maHeThong: json['ma_he_thong'] != null ? json['ma_he_thong'] as int : 0,
      tenCombo: json['ten_combo'] ?? 'Không rõ',
      moTa: json['mo_ta'] ?? '',
      gia: json['gia'] != null ? json['gia'] as int : 0,
      hinhAnh: json['hinh_anh'] ?? '',
      quantity: json['quantity'] != null ? json['quantity'] as int : 1,
    );
  }

  /// ✅ copyWith để clone object với giá trị mới
  ComboModel copyWith({
    int? maDoAn,
    int? maHeThong,
    String? tenCombo,
    String? moTa,
    int? gia,
    String? hinhAnh,
    int? quantity,
  }) {
    return ComboModel(
      maDoAn: maDoAn ?? this.maDoAn,
      maHeThong: maHeThong ?? this.maHeThong,
      tenCombo: tenCombo ?? this.tenCombo,
      moTa: moTa ?? this.moTa,
      gia: gia ?? this.gia,
      hinhAnh: hinhAnh ?? this.hinhAnh,
      quantity: quantity ?? this.quantity,
    );
  }

  /// (optional) Chuyển object về Map để gửi API
  Map<String, dynamic> toJson() {
    return {
      'ma_do_an': maDoAn,
      'ma_he_thong': maHeThong,
      'ten_combo': tenCombo,
      'mo_ta': moTa,
      'gia': gia,
      'hinh_anh': hinhAnh,
      'quantity': quantity,
    };
  }
}
