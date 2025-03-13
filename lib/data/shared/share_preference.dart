// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers
import 'dart:convert';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/data/repository/user/user_repository.dart';
import 'package:reentry/di/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'keys.dart';

class PersistentStorage {
  final SharedPreferences? _preferences;

  PersistentStorage({required SharedPreferences? preferences})
      : _preferences = preferences;

  Future<void> cacheData(
      {required Map<String, dynamic> data, required Keys key}) async {
    _preferences?.setString(key.name, jsonEncode(data));
  }

  Future<void> cacheString({required String data, required Keys key}) async {
    _preferences?.setString(key.name, data);
  }

  static Future<UserDto?> getCurrentUser() async {
    final pref = await locator.getAsync<PersistentStorage>();
    return pref.getUser();
  }

  static Future<bool> showActivity() async {
    final pref = await locator.getAsync<PersistentStorage>();
    final result = pref.getUser();
    print('user-account -> ${result?.toJson()}');
    if (result?.accountType != AccountType.citizen) {
      return false;
    }
    final data = DateTime.now().millisecondsSinceEpoch.toString();

    if (result == null || result.activityDate == null) {
      if (result != null) {
        final value =
            result.copyWith(activityDate: DateTime.now().toIso8601String());
        await UserRepository().updateUser(value);
        await PersistentStorage.cacheUserInfo(value);
      }
      return true;
    }
    await UserRepository().updateUser(
        result.copyWith(activityDate: DateTime.now().toIso8601String()));
    await PersistentStorage.cacheUserInfo(
        result.copyWith(activityDate: DateTime.now().toIso8601String()));
    print('activityState -> ${result.activityDate}');
    return DateTime.now().toDateString() !=
        DateTime.parse(result.activityDate!).toDateString();
  }

  static Future<bool> showFeeling() async {
    final pref = await locator.getAsync<PersistentStorage>();
    final currentDate = DateTime.now().toIso8601String();
    final storedDate = pref.getUser()?.feelingsDate;
    final user = pref.getUser();
    if (user?.accountType != AccountType.citizen) {
      return false;
    }
    if (storedDate == null) {
      if (user != null) {
        await pref.cacheData(
            data: user.copyWith(feelingsDate: currentDate).toJson(),
            key: Keys.user);
      }
      return true;
    }
    final storedDateValue = DateTime.parse(storedDate);
    final currentDateValue = DateTime.now();
    if (currentDateValue.difference(storedDateValue).inHours >= 8) {
      return true;
    }
    // if (currentDate == storedDate) {
    //   return false;
    // }
    //
    // await pref.cacheString(data: currentDate, key: Keys.feeling);
    return false;
  }

  Future<void> clear() async {
    await _preferences?.clear();
  }

  static Future<void> logout() async {
    final pref = await locator.getAsync<PersistentStorage>();
    final email = pref.getStringFromCache(Keys.remember);
    await pref.clear();
    if (email != null) {
      pref.cacheString(data: email, key: Keys.remember);
    }
  }

  static Future<void> cacheUserInfo(UserDto data) async {
    final pref = await locator.getAsync<PersistentStorage>();
    await pref.cacheData(data: data.toJson(), key: Keys.user);
  }

  static void rememberMe(String email) async {
    final pref = await locator.getAsync<PersistentStorage>();
    await pref.cacheString(data: email, key: Keys.remember);
  }

  static Future<String?> getRememberMeEmail() async {
    final pref = await locator.getAsync<PersistentStorage>();
    return pref.getStringFromCache(Keys.remember);
  }

  Map<String, dynamic>? getDataFromCache(Keys key) {
    final result = _preferences?.getString(key.name);
    if (result == null) {
      return null;
    }
    return jsonDecode(result);
  }

  String? getStringFromCache(Keys key) {
    return _preferences?.getString(key.name);
  }

  UserDto? getUser() {
    final result = getDataFromCache(Keys.user);
    if (result == null) {
      return null;
    }
    return UserDto.fromJson(result);
  }

  destroy() async {
    await _preferences?.clear();
  }
}
