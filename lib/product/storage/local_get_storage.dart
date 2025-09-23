//import 'package:app/data/models/user/user_model.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final box = GetStorage();
  // RegisterModel? user;

  // LocalStorage({this.user}) {
  //   getUser();
  // }
  Future<void> saveString(String key, String value) async {
    await box.write(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await box.write(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await box.write(key, value);
  }

  Future<void> saveBool(String key, bool value) async {
    await box.write(key, value);
  }

  Future<void> saveList(String key, List<dynamic> value) async {
    await box.write(key, value);
  }

  Future<void> saveMap(String key, Map<String, dynamic> value) async {
    await box.write(key, value);
  }

  //* Specific Map
  Future<void> saveUserAsMap(Map<String, dynamic> value) async {
    await box.write('User', value);
  }

  Future<Map<String, dynamic>?> readUserAsMap() async {
    return box.read('User');
  }

  // Future<bool> getUser() async {
  //   final user = await box.read('User') as Map<String, dynamic>?;

  //   if (user != null) {
  //     this.user = RegisterModel.fromJson(user);
  //     return true;
  //   } else {
  //     this.user = null;
  //     return false;
  //   }
  // }

  String? getString(String key) {
    return box.read(key);
  }

  int? getInt(String key) {
    return box.read(key);
  }

  double? getDouble(String key) {
    return box.read(key);
  }

  bool? getBool(String key) {
    return box.read(key);
  }

  List<dynamic>? getList(String key) {
    return box.read(key);
  }

  Map<String, dynamic>? getMap(String key) {
    return box.read(key);
  }

  Future<void> remove(String key) async {
    await box.remove(key);
  }

  Future<void> clearAll() async {
    //  user = null;
    await box.erase();
  }
}
