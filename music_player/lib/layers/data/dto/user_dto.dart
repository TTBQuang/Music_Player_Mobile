import 'package:music_player/layers/domain/entity/user.dart';

class UserDto extends User{
  UserDto(super.id, super.username, super.password, super.displayName);

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}