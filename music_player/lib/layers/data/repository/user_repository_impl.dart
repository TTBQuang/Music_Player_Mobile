import 'package:music_player/layers/data/source/network/user_network.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_repository.dart';
import '../source/local/user_local_storage.dart';

class UserRepositoryImpl extends UserRepository{
  final UserNetwork userNetwork;
  final UserLocalStorage userLocalStorage;

  UserRepositoryImpl(this.userNetwork, this.userLocalStorage);

  @override
  Future<bool> registerUser(String username, String password) async {
    return await userNetwork.registerUser(username, password);
  }

  @override
  Future<User> login(String username, String password) async {
    return await userNetwork.login(username, password);
  }

  @override
  Future<void> saveCredentials(String username, String password) async {
    userLocalStorage.saveCredentials(username, password);
  }

  @override
  Future<Map<String, String?>> getCredentials() async {
    return userLocalStorage.getCredentials();
  }

  @override
  Future<void> deleteCredentials() async {
    userLocalStorage.deleteCredentials();
  }
}