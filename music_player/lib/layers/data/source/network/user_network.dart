import '../../dto/user_dto.dart';

abstract class UserNetwork{
  Future<bool> registerUser(String username, String password);
  Future<UserDto> login(String username, String password);
}