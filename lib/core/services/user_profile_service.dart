import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/delegate_models.dart';

class UserProfileService {
  UserProfileService._();
  static final UserProfileService instance = UserProfileService._();

  static const _profileKey = 'user_profile';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> hasProfile() async {
    await init();
    return _prefs!.containsKey(_profileKey);
  }

  Future<UserProfile?> getProfile() async {
    await init();
    final raw = _prefs!.getString(_profileKey);
    if (raw == null) return null;
    return UserProfile.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    await init();
    await _prefs!.setString(_profileKey, json.encode(profile.toJson()));
  }
}
