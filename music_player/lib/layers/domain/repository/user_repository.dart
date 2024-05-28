import '../entity/user.dart';

abstract class UserRepository{
  Future<bool> registerUser(String username, String password);
  Future<User> login(String username, String password);
  Future<void> saveCredentials(String username, String password);
  Future<Map<String, String?>> getCredentials();
  Future<void> deleteCredentials();
}