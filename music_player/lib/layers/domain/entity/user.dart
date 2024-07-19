import '../../data/dto/user_dto.dart';

class User {
  int id;
  String username;
  String password;
  String displayName;
  String role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.displayName,
    required this.role,
  });

  User clone() {
    return User(
      id: id,
      username: username,
      displayName: displayName,
      password: password,
      role: role
    );
  }

  factory User.fromUserDto(UserDto userDto) {
    return User(
      id: userDto.id,
      username: userDto.username,
      password: userDto.password,
      displayName: userDto.displayName,
      role: userDto.role
    );
  }
}
