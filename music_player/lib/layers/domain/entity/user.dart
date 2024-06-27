import '../../data/dto/user_dto.dart';

class User {
  int id;
  String username;
  String password;
  String displayName;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.displayName,
  });

  User clone() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      password: password,
    );
  }

  factory User.fromUserDto(UserDto userDto) {
    return User(
      id: userDto.id,
      username: userDto.username,
      password: userDto.password,
      displayName: userDto.displayName
    );
  }
}
