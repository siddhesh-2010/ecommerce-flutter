import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStore {
  const ProfileStore._();

  static Future<void> storeProfileImage(String imagePath, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId.toString();
    await prefs.setString(key, imagePath);
  }

  static Future<String?> getProfileImage(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = userId.toString();
    return prefs.getString(key);
  }

}