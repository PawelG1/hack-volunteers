import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/volunteer_profile.dart';

/// Service for managing volunteer profile data in local storage
class ProfileStorageService {
  static const String _profileKey = 'volunteer_profile';

  /// Save volunteer profile to local storage
  Future<void> saveProfile(VolunteerProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(profile.toJson());
      await prefs.setString(_profileKey, jsonString);
      print('✅ Profile saved successfully');
    } catch (e) {
      print('❌ Error saving profile: $e');
      rethrow;
    }
  }

  /// Load volunteer profile from local storage
  Future<VolunteerProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_profileKey);
      
      if (jsonString == null) {
        print('ℹ️ No profile found in storage');
        return null;
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final profile = VolunteerProfile.fromJson(jsonMap);
      print('✅ Profile loaded successfully');
      return profile;
    } catch (e) {
      print('❌ Error loading profile: $e');
      return null;
    }
  }

  /// Clear profile from local storage
  Future<void> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
      print('✅ Profile cleared successfully');
    } catch (e) {
      print('❌ Error clearing profile: $e');
      rethrow;
    }
  }

  /// Check if profile exists in storage
  Future<bool> hasProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_profileKey);
    } catch (e) {
      print('❌ Error checking profile existence: $e');
      return false;
    }
  }
}
