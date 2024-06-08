import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music_player/layers/data/source/local/user_local_storage.dart';

import '../../../../utils/constants.dart';

class UserLocalStorageImpl implements UserLocalStorage {
  final FlutterSecureStorage _secureStorage;

  UserLocalStorageImpl(this._secureStorage);

  @override
  Future<void> saveCredentials(String username, String password) async {
    _secureStorage.write(key: Constants.usernameKey, value: username);
    _secureStorage.write(key: Constants.passwordKey, value: password);
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    String? username = await _secureStorage.read(key: Constants.usernameKey);
    String? password = await _secureStorage.read(key: Constants.passwordKey);
    return {
      'username': username,
      'password': password,
    };
  }

  @override
  Future<void> deleteCredentials() async {
    _secureStorage.delete(key: Constants.usernameKey);
    _secureStorage.delete(key: Constants.passwordKey);
  }
}