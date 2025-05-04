import 'dart:convert';

import 'package:maternity_app/core/error/exceptions.dart';
import 'package:maternity_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const cachedUserKey = 'CACHED_USER';

/// UserLocalDataSource interface for local user operations
abstract class UserLocalDataSource {
  /// Get cached user data
  Future<UserModel> getCachedUserData();
  
  /// Cache user data
  Future<void> cacheUserData(UserModel user);
  
  /// Clear cached user data
  Future<void> clearCachedUserData();
}

/// SharedPreferences implementation of UserLocalDataSource
class SharedPrefsUserDataSource implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  SharedPrefsUserDataSource({required this.sharedPreferences});
  
  @override
  Future<UserModel> getCachedUserData() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    
    if (jsonString == null) {
      throw CacheException(message: 'No cached user data found');
    }
    
    try {
      return UserModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw CacheException(message: 'Failed to parse cached user data');
    }
  }
  
  @override
  Future<void> cacheUserData(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cachedUserKey,
        json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache user data');
    }
  }
  
  @override
  Future<void> clearCachedUserData() async {
    try {
      await sharedPreferences.remove(cachedUserKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached user data');
    }
  }
} 