class GheModel {
  final int maGhe;
  final String viTriGhe;
  final int maLoaiGhe;
  final String tenLoaiGhe;
  final int giaTien;
  final bool daDat;

  GheModel({
    required this.maGhe,
    required this.viTriGhe,
    required this.maLoaiGhe,
    required this.tenLoaiGhe,
    required this.giaTien,
    required this.daDat,
  });

  factory GheModel.fromJson(Map<String, dynamic> json) {
    return GheModel(
      maGhe: json['ma_ghe'],
      viTriGhe: json['vi_tri_ghe'],
      maLoaiGhe: json['ma_loai_ghe'],
      tenLoaiGhe: json['ten_loai_ghe'],
      giaTien: json['gia_tien'],
      daDat: json['da_dat'],
    );
  }

  /// Extension-like getters để bóc row/col từ vị trí ghế
  int get row {
    final letterPart =
        viTriGhe.replaceAll(RegExp(r'[^A-Za-z]'), '').toUpperCase();
    if (letterPart.length == 1) {
      return letterPart.codeUnitAt(0) -
          'A'.codeUnitAt(0); // A => 0, B => 1, ...
    } else if (letterPart.length == 2) {
      return ((letterPart.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1) * 26) +
          (letterPart.codeUnitAt(1) - 'A'.codeUnitAt(0));
    }
    return 0;
  }

  int get col {
    final numberPart = viTriGhe.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numberPart) ?? 0;
  }
}
