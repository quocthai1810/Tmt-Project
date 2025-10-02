import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tmt_project/core/constants/env.dart';

/// Provider quản lý dữ liệu tin tức
class NewsProvider extends ChangeNotifier {
  // ===================== State =====================
  final List<Map<String, dynamic>> _newsList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchText = "";
  String? _error;

  // ===================== Getter =====================
  List<Map<String, dynamic>> get newsList {
    if (_searchText.isEmpty) return _newsList;
    return _newsList.where((news) {
      final title = (news["tieu_de"] ?? "").toString().toLowerCase();
      return title.contains(_searchText.toLowerCase());
    }).toList();
  }

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  // ===================== Action =====================

  /// Cập nhật text tìm kiếm
  void updateSearch(String value) {
    if (_searchText == value) return; // tránh notifyListeners thừa
    _searchText = value;
    notifyListeners();
  }

  /// Load tin tức (có phân trang)
  Future<void> loadNews() async {
    if (_isLoading || !_hasMore) return;

    _setLoading(true);
    try {
      final newData = await _fetchNewsPage(_currentPage);

      if (newData.isNotEmpty) {
        _newsList.addAll(newData);
        _currentPage++;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      _error = "Không thể tải dữ liệu";
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh danh sách (reset toàn bộ state)
  Future<void> refreshNews() async {
    _newsList.clear();
    _currentPage = 1;
    _hasMore = true;
    _error = null;
    notifyListeners();
    await loadNews();
  }

  // ===================== Helper =====================

  /// Cập nhật trạng thái loading
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Gọi API lấy tin tức theo từng trang
  Future<List<Map<String, dynamic>>> _fetchNewsPage(int page) async {
    final url = Uri.parse(
        "$apiTMT/TinTuc/LayTinTucTheoTrang?trang=$page");

    try {
      final response =
          await http.get(url).timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["data"] != null) {
        return List<Map<String, dynamic>>.from(data["data"]);
      } else {
        throw Exception(data["message"] ?? "Lỗi không xác định");
      }
    } catch (e) {
      throw Exception("Lỗi mạng: $e");
    }
  }
}
