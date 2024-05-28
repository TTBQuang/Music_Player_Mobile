import '../../../domain/entity/user.dart';

abstract class UserLocalStorage{
  Future<void> saveCredentials(String username, String password);
  Future<Map<String, String?>> getCredentials();
  Future<void> deleteCredentials();
}