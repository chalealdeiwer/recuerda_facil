import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUser {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();
    if (T == String) {
      return prefs.getString(key) as T?;
    }
    if (T == int) {
      return prefs.getInt(key) as T?;
    }
    if (T == double) {
      return prefs.getDouble(key) as T?;
    }
    if (T == bool) {
      return prefs.getBool(key) as T?;
    }
    if (T == List<String>) {
      return prefs.getStringList(key) as T?;
    }
    return null;
  }

  Future<bool> remove(String key) async {
    final prefs = await getSharedPrefs();
    return await prefs.remove(key);
  }

  Future<void> setValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();
    if (value is String) {
      await prefs.setString(key, value);
    }
    if (value is int) {
      await prefs.setInt(key, value);
    }
    if (value is double) {
      await prefs.setDouble(key, value);
    }
    if (value is bool) {
      await prefs.setBool(key, value);
    }
    if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }
}
