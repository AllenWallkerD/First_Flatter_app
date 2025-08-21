import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../error/exceptions.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance => _instance ??= LocalStorageService._internal();
  
  SharedPreferences? _prefs;
  
  LocalStorageService._internal();

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw CacheException('LocalStorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    try {
      return await prefs.setString(key, value);
    } catch (e) {
      throw CacheException('Failed to save string: $e');
    }
  }

  String? getString(String key) {
    try {
      return prefs.getString(key);
    } catch (e) {
      throw CacheException('Failed to get string: $e');
    }
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    try {
      return await prefs.setInt(key, value);
    } catch (e) {
      throw CacheException('Failed to save int: $e');
    }
  }

  int? getInt(String key) {
    try {
      return prefs.getInt(key);
    } catch (e) {
      throw CacheException('Failed to get int: $e');
    }
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    try {
      return await prefs.setBool(key, value);
    } catch (e) {
      throw CacheException('Failed to save bool: $e');
    }
  }

  bool? getBool(String key) {
    try {
      return prefs.getBool(key);
    } catch (e) {
      throw CacheException('Failed to get bool: $e');
    }
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    try {
      return await prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException('Failed to save double: $e');
    }
  }

  double? getDouble(String key) {
    try {
      return prefs.getDouble(key);
    } catch (e) {
      throw CacheException('Failed to get double: $e');
    }
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException('Failed to save string list: $e');
    }
  }

  List<String>? getStringList(String key) {
    try {
      return prefs.getStringList(key);
    } catch (e) {
      throw CacheException('Failed to get string list: $e');
    }
  }

  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      throw CacheException('Failed to save JSON: $e');
    }
  }

  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException('Failed to get JSON: $e');
    }
  }

  // List of JSON operations
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = json.encode(value);
      return await setString(key, jsonString);
    } catch (e) {
      throw CacheException('Failed to save JSON list: $e');
    }
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    try {
      final jsonString = getString(key);
      if (jsonString == null) return null;
      final decoded = json.decode(jsonString) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      throw CacheException('Failed to get JSON list: $e');
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    try {
      return await prefs.remove(key);
    } catch (e) {
      throw CacheException('Failed to remove key: $e');
    }
  }

  Future<bool> clear() async {
    try {
      return await prefs.clear();
    } catch (e) {
      throw CacheException('Failed to clear storage: $e');
    }
  }

  bool containsKey(String key) {
    try {
      return prefs.containsKey(key);
    } catch (e) {
      throw CacheException('Failed to check key existence: $e');
    }
  }

  Set<String> getKeys() {
    try {
      return prefs.getKeys();
    } catch (e) {
      throw CacheException('Failed to get keys: $e');
    }
  }
}
