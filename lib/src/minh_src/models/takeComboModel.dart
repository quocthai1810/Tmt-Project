// form hiện tại đang gặp 1 số vấn đề về việc ko parse được từ trang takeSeat qua takeCombo
// nên tạm thời comment đi để tránh lỗi, khi nào rảnh sẽ fix sau

class ComboModel {
  final int maDoAn;
  final int maHeThong;
  final String tenCombo;
  final String moTa;
  final String hinhAnh;
  final int gia;

  ComboModel({
    required this.maDoAn,
    required this.maHeThong,
    required this.tenCombo,
    required this.moTa,
    required this.hinhAnh,
    required this.gia,
  });

  factory ComboModel.fromJson(Map<String, dynamic> json) {
    return ComboModel(
      maDoAn: json['ma_do_an'] as int,
      maHeThong: json['ma_he_thong'] as int,
      tenCombo: json['ten_combo'] ?? '',
      moTa: json['mo_ta'] ?? '',
      hinhAnh: json['hinh_anh'] ?? '',
      gia: json['gia'] as int,
    );
  }
}
