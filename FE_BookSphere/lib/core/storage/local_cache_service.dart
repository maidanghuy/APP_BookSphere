import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// BS-APP-28 – Local Cache cơ bản
///
/// Centralized cache service dùng SharedPreferences.
/// Không cache dữ liệu nhạy cảm như token hay password.
class LocalCacheService {
  const LocalCacheService._();

  // ── Keys ─────────────────────────────────────────────────

  static const _keyFinesList = 'cache_fines_list';
  static const _keyUserInfo = 'cache_user_info';
  static const _keyNotifications = 'cache_notifications';

  // ── Fines ────────────────────────────────────────────────

  static Future<void> saveFinesList(List<Map<String, dynamic>> fines) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFinesList, jsonEncode(fines));
  }

  static Future<List<Map<String, dynamic>>> loadFinesList() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFinesList);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearFinesList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFinesList);
  }

  // ── User info (non-sensitive) ─────────────────────────────

  static Future<void> saveUserInfo(Map<String, String?> info) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserInfo, jsonEncode(info));
  }

  static Future<Map<String, String?>> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUserInfo);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map;
      return map.map(
        (k, v) => MapEntry(k.toString(), v?.toString()),
      );
    } catch (_) {
      return {};
    }
  }

  static Future<void> clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserInfo);
  }

  // ── Notifications ─────────────────────────────────────────

  static Future<void> saveNotifications(
      List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNotifications, jsonEncode(items));
  }

  static Future<List<Map<String, dynamic>>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyNotifications);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNotifications);
  }

  // ── Clear all ─────────────────────────────────────────────

  /// Xóa toàn bộ cache dữ liệu thường (không xóa token).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_keyFinesList),
      prefs.remove(_keyUserInfo),
      prefs.remove(_keyNotifications),
    ]);
  }
}
