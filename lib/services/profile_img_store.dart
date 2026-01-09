import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStore {
  const ProfileStore._();

  static Future<void> storeProfileImage(String imagePath, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    print('The hashcode is ${prefs.hashCode}');
    final key = userId.toString();
    await prefs.setString(key, imagePath);
  }

  static Future<String?> getProfileImage(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    print('The hashcode is1 ${prefs.hashCode}');

    final key = userId.toString();
    
    return prefs.getString(key);
  }

}