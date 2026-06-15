import 'dart:convert';

import 'package:flutter_foundation_kit/cport/PreferenceRepositoryPort.dart';
import 'package:flutter_foundation_kit/cutil/Codable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceRepositoryImpl extends PreferenceRepositoryPort {
  PreferenceRepositoryImpl(super.boxName);

  @override
  Future<void> setValue<K, V>(K key, V? value) async {
    if (value == null) {
      return delete(key);
    }
    final prefs = await SharedPreferences.getInstance();
    final storageKey = _storageKey(key);
    if (value is String) {
      await prefs.setString(storageKey, value);
      return;
    }
    if (value is int) {
      await prefs.setInt(storageKey, value);
      return;
    }
    if (value is bool) {
      await prefs.setBool(storageKey, value);
      return;
    }
    if (value is double) {
      await prefs.setDouble(storageKey, value);
      return;
    }
    if (value is List<String>) {
      await prefs.setStringList(storageKey, value);
      return;
    }
    if (value is Codable) {
      await prefs.setString(storageKey, jsonEncode(value.toJson()));
      return;
    }
    if (value is Map<String, dynamic> || value is List) {
      await prefs.setString(storageKey, jsonEncode(value));
      return;
    }
    throw ArgumentError.value(
      value,
      'value',
      'Unsupported preference value type. Use primitives, List<String>, Map<String, dynamic>, List, or Codable.',
    );
  }

  @override
  Future<V?> getValue<K, V>(K key) async {
    final prefs = await SharedPreferences.getInstance();
    final storageKey = _storageKey(key);
    if (V == String) {
      return prefs.getString(storageKey) as V?;
    }
    if (V == int) {
      return prefs.getInt(storageKey) as V?;
    }
    if (V == bool) {
      return prefs.getBool(storageKey) as V?;
    }
    if (V == double) {
      return prefs.getDouble(storageKey) as V?;
    }
    if (V == List<String>) {
      return prefs.getStringList(storageKey) as V?;
    }
    final value = prefs.getString(storageKey);
    if (value == null) {
      return null;
    }
    return jsonDecode(value) as V;
  }

  @override
  Future<void> delete<K>(K key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey(key));
  }

  String _storageKey<K>(K key) => '$boxName.$key';
}
